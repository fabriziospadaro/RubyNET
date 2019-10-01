require 'socket'
require 'securerandom'

class Server
  def initialize(socket_address, socket_port)
    Thread.abort_on_exception = true
    @server_socket = TCPServer.open(socket_port, socket_address)

    @connections_details = {}
    @connections_details[:clients] = {}
    @connections_details[:socket] = @server_socket

    puts 'Started server.........'
    run
  end

  def run
    loop do
      #wait for client to connect
      client_connection = @server_socket.accept
      Thread.start(client_connection) do |conn|
        conn_id = generate_unique_id
        if @connections_details[:clients][conn_id]
          conn.puts "This player already exist"
          conn.puts "quit"
          conn.kill self
        end
        puts "Connection established #{conn_id} => #{conn}"
        #variable_type%variable_name%value
        #send connection signal with the assigned id for the client
        p "sending message to connected client"
        broadcast(conn, "04%#{conn_id}")

        p "sending message to all clients"
        broadcast(@connections_details[:clients].values, "02%#{conn_id}")

        @connections_details[:clients][conn_id] = conn
        listen(conn)
      end
    end.join
  end

  def listen(conn)
    # todo: create an enum RPC that contains info about who to send the message: (ALL,OTHERS,SERVER,Etc..)

    # when we get a message from a client, propagate that message to all connected clients
    # except the sender
    loop do
      data = conn.recvfrom(1024)[0].unpack('m*')[0]
      p "Recived: #{data} at #{Time.now}"
      listeners = @connections_details[:clients].values - [conn]
      broadcast(listeners, data)
    end
  end

  def generate_unique_id
    SecureRandom.hex(13)
  end

  def broadcast(clients, data)
    data = [data]
    [clients].flatten.each do |client|
      p "wrote #{data} to  #{client} at #{Time.now}"
      client.write(data.pack('m*')) rescue nil
    end
  end

end


Server.new(8080, "localhost")