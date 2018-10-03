module Events
  module Users
    class Created < Events::Users::Event
      data_attributes :active, :description, :name, :visible

      # @param [User] user
      # @return [User]
      def apply(user)
        user.active = active
        user.description = description
        user.name = name
        user.visible = visible

        user
      end
    end
  end
end
