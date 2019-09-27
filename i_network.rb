require_relative 'events'
#todo: check socket.send('some message\000', 0)
class INetwork
  include Events
  attr_reader :events
  attr_accessor :unique_id

  def initialize
    @unique_id = nil
    @events = {
        message_sent: {},
        message_received: {}
    }
    create_events
  end

  def configure(local, socket)
    @is_local = local
    @socket = socket
  end

end