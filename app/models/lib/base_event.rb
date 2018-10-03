# This is the BaseEvent class that all Events inherit from.
# It takes care of serializing `data` and `metadata` via json
# It defines setters and accessors for the defined `data_attributes`
# After create, it calls `apply` to apply changes.
#
# Subclasses must define the `apply` method.
class Lib::BaseEvent < ActiveRecord::Base
  before_validation :preset_aggregate
  before_create :apply_and_persist
  after_create :dispatch

  self.abstract_class = true

  # Apply the event to the aggregate passed in.
  # Must return the aggregate.
  def apply(aggregate)
    raise NotImplementedError
  end

  # Aggregate name the event will belong to
  # Should be a symbol. Example: `:user`
  def self.aggregate_name
    raise NotImplementedError, "Events must belong to an aggregate"
  end

  # Replays the event on any given aggregate
  # @param [Object] aggregate
  def replay(aggregate)
    event_class = self.metadata["klass"].constantize
    event_class.new(self.data).data.apply(aggregate)
  end

  after_initialize do
    self.data ||= {}
    self.metadata ||= { klass: self.class.name }
  end

  # Define attributes to be serialized in the `data` column.
  # It generates setters and getters for those.
  #
  # Example:
  #
  # class MyEvent < Lib::BaseEvent
  #   data_attributes :title, :description, :drop_id
  # end
  #
  # MyEvent.create!(
  def self.data_attributes(*attrs)
    attrs.map(&:to_s).each do |attr|
      define_method attr do
        self.data ||= {}
        self.data[attr]
      end

      define_method "#{attr}=" do |arg|
        self.data ||= {}
        self.data[attr] = arg
      end
    end
  end

  def aggregate=(model)
    public_send "#{aggregate_name}=", model
  end

  # Return the aggregate that the event will apply to
  def aggregate
    public_send aggregate_name
  end

  def aggregate_id=(id)
    public_send "#{aggregate_name}_id=", id
  end

  def aggregate_id
    public_send "#{aggregate_name}_id"
  end

  def build_aggregate
    public_send "build_#{aggregate_name}"
  end

  private def preset_aggregate
    # Build aggregate when the event is creating an aggregate
    self.aggregate ||= build_aggregate
  end

  # Apply the transformation to the aggregate and save it.
  private def apply_and_persist
    # Lock! (all good, we're in the ActiveRecord callback chain transaction)
    aggregate.lock! if aggregate.persisted?

    # Apply!
    self.aggregate = data.apply(aggregate)

    # Persist!
    aggregate.save!
    self.aggregate_id = aggregate.id if aggregate_id.nil?
  end

  delegate :aggregate_name, to: :class

  private def dispatch
    Events::Dispatcher.dispatch(self)
  end
end

