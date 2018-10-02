# The Base command mixin that commands include.
#
# A Command has the following public api.
#
# ```
#   MyCommand.call(user: ..., post: ...) # shorthand to initialize, validate and execute the command
#   command = MyCommand.new(user: ..., post: ...)
#   command.valid? # true or false
#   command.errors # +> <ActiveModel::Errors ... >
#   command.call # validate and execute the command
# ```
#
# `call` will raise an `ActiveRecord::RecordInvalid` error if it fails validations.
#
# Commands including the `Command::Base` mixin must:
# * list the attributes the command takes
# * implement `build_event` which returns a non-persisted event or nil for noop.
#
# Ex:
#
# ```
#   class MyCommand
#     include Command
#
#     attributes :user, :post
#
#     def build_event
#       Event.new(...)
#     end
#   end
# ```
module Lib
  module Command
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Validations

      # @param [Hash<Symbol, Object>] args
      def initialize(args = {})
        args.each { |key, value| instance_variable_set("@#{key}", value) }
        after_initialize
      end
    end

    class_methods do
      # Run validations and persist the event.
      #
      # On success: returns the event
      # On noop: returns nil
      # On failure: raise an ActiveRecord::RecordInvalid error
      def call(args = {})
        new(args).call
      end

      # Define the attributes.
      # They are set when initializing the command as a hash and
      # are all accessible as getter methods.
      #
      # ex: `attributes :post, :user, :ability`
      def attributes(*args)
        attr_accessor(*args)
      end
    end

    def call
      return nil if event.nil?
      raise "The event should not be persisted at this stage!" if event.persisted?

      validate!
      execute!

      event
    end

    def validate!
      valid? || raise(ActiveRecord::RecordInvalid, self)
    end

    # A new record or nil if noop
    def event
      @event ||= build_event
    end

    # Save the event. Should not be overwritten by the command as side effects
    # should be implemented via Reactors triggering other Events.
    private def execute!
      event.save!
    end

    # Returns a new event record or nil if noop
    private def build_event
      raise NotImplementedError
    end

    # Hook to set default values
    private def after_initialize
      # noop
    end
  end
end
