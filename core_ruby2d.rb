require 'ruby2d'
require_relative 'grid'
require_relative 'point'
require_relative 'player'
require_relative 'input'
require_relative 'network_manager'
require 'socket'


set title: "Client Server Test"

Thread.abort_on_exception = true

width = 6
height = 6
block_size = 64
set width: width * block_size, height: height * block_size
@grid = Grid.new(6, 6, 64)

@players = []
@player = Player.new(@grid)
@player.mark_as_local
@players << @player

@ntw_manager = NetworkManager.new(auto_connect: true, client: @player)
Thread.new {@ntw_manager.listen}

def add_player(client_id)
  p "Client connected"
  other_player = Player.new(@grid)
  other_player.unique_id = client_id
  @ntw_manager.register_client(other_player)
  @players << other_player
end

def first_or_add_player(client_id)
  @players.each do |player|
    if player.unique_id == client_id
      return player
    end
  end
  add_player(client_id)[-1]
end

network_thread = Thread.new do
  @ntw_manager.on :client_connected do |client_id|
    add_player(client_id)
  end

  @ntw_manager.on :client_disconnected do |client_id|
    puts "On client disconnected"
  end

  @ntw_manager.on :server_connected do |assigned_client_id|
    puts "Connected to server with id: #{assigned_client_id}"
    @player.unique_id = assigned_client_id
  end

  @ntw_manager.on :server_closed do |error_msg|
    puts "On server closed"
  end


  @player.on :message_sent do |raw_data|
    puts "On message sent"
  end

  @player.on :message_received do |network_message|
    player = first_or_add_player(network_message.client_id)
    p "Recived #{network_message} at #{Time.now}"
    data = network_message.data.to_a.flatten
    player.send("#{data[0]}=".to_sym, data[1])
  end

end

tick = 0

Thread.new do
  sleep 0.1
  network_thread
end.join


on :key_down do |event|
  @player.on_input_detected(event.key)
end

update do
  if tick % 60 == 0
    set background: 'random'
  end
  tick += 1
end

show
