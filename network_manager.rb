require_relative 'events'
require_relative 'network_message'

class NetworkManager
  include Events
  attr_reader :socket, :events

  def initialize(ip: "localhost", port: 8080, auto_connect: false, client:)
    @socket = nil
    @ip = ip
    @port = port
    @clients = []
    @local_client = nil
    connect(client) if auto_connect
    @events = {
        client_connected: {},
        client_disconnected: {},
        server_connected: {},
        server_closed: {}
    }
    create_events
  end

  def connect(client)
    @socket = TCPSocket.open(@ip, @port) rescue 'Connection failed'
    client.socket = @socket
    @clients << client
    @local_client = client
  end

  def disconnect
    @socket.close
  end

  def register_client(client)
    @clients << client
  end

  def dispatch(method:, args:)
    @local_client.send(method, *args)
  end

  # msg detection thread
  def listen
    loop do
      data = @socket.recvfrom(1024)[0]
      values = data.unpack('m*')[0].split('%')
      case values[0]
      when '00'
        dispatch(method: :on_message_sent, args: [values[1]])
      when '01'
        dispatch(method: :on_message_received, args: NetworkMessage.deserialize(values))
      when '02'
        on_client_connected(values[1])
      when '03'
        on_client_disconnected(values[1])
      when '04'
        on_server_connected(values[1])
      when '05'
        on_server_closed(values[1])
      end
    end
  end

end