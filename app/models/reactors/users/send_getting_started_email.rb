module Reactors
  module Users
    class SendGettingStartedEmail
      def self.call(event)
        user = event.user
        name = event.name

        puts "Reacting to event: #{name}, on model User ID: #{user.id}"
      end
    end
  end
end
