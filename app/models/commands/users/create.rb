module Commands
  module Users
    class Create
      include Lib::Command

      attributes :description, :name

      validates :description, presence: true, length: { minimum: 10 }
      validates :name, presence: true, length: { minimum: 5 }

      private def build_event
        Events::Users::Created.new(
          active: true,
          description: description,
          name: name,
          visible: true,
        )
      end
    end
  end
end
