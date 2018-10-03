UserCreated = Struct.new(:active, :description, :name, :visible) do
  def type
    "UserCreated"
  end

  def apply(aggregate)
    aggregate.active = self.active
    aggregate.description = self.description
    aggregate.name = self.name
    aggregate.visible = self.visible
    aggregate
  end
end
