module Events
  module Users
    class Event < Lib::BaseEvent
      self.table_name = :user_events

      belongs_to :user, autosave: false

      def self.aggregate_name
        :user
      end
    end
  end
end
