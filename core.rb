require 'ruby2d'
require_relative 'grid'
require_relative 'point'
require_relative 'player'
require_relative 'input'
require_relative 'network_manager'
require 'socket'

input = Input.new

grid = Grid.new(6, 6, "#")
drawable_objects = []

player = Player.new(grid)
players = []
players << player
drawable_objects << player
system 'clear'

threads = []

graphic_refresh_rate = 0.3

ntw_manager = NetworkManager.new(auto_connect: true, client: player)
player.configure(true, ntw_manager.socket)

threads << Thread.new {ntw_manager.listen}

threads << Thread.new do
  ntw_manager.on :client_connected do |client_id|
    other_player = Player.new(grid)
    other_player.configure(false, ntw_manager.socket)
    other_player.unique_id = client_id
    ntw_manager.register_client(other_player)
    players << other_player
    drawable_objects << other_player
  end

  ntw_manager.on :client_disconnected do |client_id|
    # todo: remove player with that id
  end

  ntw_manager.on :server_connected do |assigned_client_id|
    puts "Connected to server with id: #{assigned_client_id}"
    player.unique_id = assigned_client_id
  end

  ntw_manager.on :server_closed do |error|
    raise "Server closed"
  end


  player.on :message_sent do |byte_data|
    p "Sent a message"
  end

  player.on :message_received do |sender_id, byte_data|
    p "Recived a message"
  end
end

#graphic thread

threads << Thread.new do
  loop {
    grid.clean
    drawable_objects.each(&:draw)
    grid.draw
    sleep graphic_refresh_rate
  }
end

input_detection_rate = 0.02
#input thread
threads << Thread.new do
  loop {
    data = input.get.downcase
    player.on_input_detected(data) unless data.empty?
    sleep input_detection_rate
  }
end


threads.each(&:join)