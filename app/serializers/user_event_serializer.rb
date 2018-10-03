class UserEventSerializer

  # this method is not great
  def self.load(data)
    return nil if data.nil?

    type = data.delete("type") # zz
    event = type.constantize.new

    data.each do |key, value|
      event[key] = value
    end

    event
  end

  def self.dump(event)
    event.to_h.merge(type: event.type)
  end
end
