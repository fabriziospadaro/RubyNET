require_relative 'events'
#todo: check socket.send('some message\000', 0)
class INetwork
  include Events
  attr_reader :events
  attr_accessor :unique_id, :socket

  def initialize
    @is_local = false
    @socket = nil
    @unique_id = nil
    @events = {
        message_sent: {},
        message_received: {}
    }
    create_events
  end

  def mark_as_local
    @is_local = true
  end

  def local?
    return @is_local
  end

  def serialize(variable_name, value)
    case value.class.to_s
    when "Point"
      serialized_value = "#{value.x}%#{value.y}"
    else
      serialized_value = value
    end
    formatted_message = "01%#{@unique_id}%#{value.class}%#{variable_name}%#{serialized_value}"
    p "Sending: #{formatted_message} to server at #{Time.now}"
    @socket.write([formatted_message].pack('m*'))
  end

end