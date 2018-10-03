module Events
  module Users
    class Updated < Events::Users::Event
      data_attributes :active, :description, :id, :name, :visible

      def apply(user)
        user.active = active
        user.description = description
        user.name = name
        user.visible = visible

        user
      end

      private def preset_aggregate
        self.aggregate ||= ::User.find(id)
      end
    end
  end
end
