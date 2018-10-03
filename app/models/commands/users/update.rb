module Commands
  module Users
    class Update
      include Lib::Command

      attributes :active, :description, :id, :name, :visible

      validates :id, presence: true
      validates :active, inclusion: { in: [true, false] }
      validates :name, presence: true, length: { minimum: 5 }
      validates :visible, inclusion: { in: [true, false] }

      private def build_event
        Events::Users::Event.new(
          id: id,
          data: UserUpdated.new(
            active: active,
            description: description,
            name: name,
            visible: visible,
          )
        )
      end
    end
  end
end
