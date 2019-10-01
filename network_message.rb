class NetworkMessage
  attr_reader :client_id, :data

  def initialize(client_id, data)
    @client_id = client_id
    @data = data
  end

  def self.deserialize(values)
    case values[2]
    when "Point"
      data = Point.new(values[4].to_i, values[5].to_i)
    when "Integer"
      data = values[4].to_i
    else
      data = values[4]
    end
    self.new(values[1], {values[3].to_sym => data})
  end

end