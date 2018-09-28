module Events
  module Users
    class BaseEvent < Lib::BaseEvent
      self.table_name = :user_events

      belongs_to :user, class_name: "::User", autosave: false
    end
  end
end
