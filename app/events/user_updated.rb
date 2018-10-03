UserUpdated = Struct.new(:active, :description, :name, :visible) do
  def type
    "UserUpdated"
  end
end
