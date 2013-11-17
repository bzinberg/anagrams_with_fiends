class GameEventController < WebsocketRails::BaseController
  def initialize_session
    # run when a socket is set up
    puts 'session initialized'
  end

  def client_connected
    puts 'client connected'
    send_message :connect, @table.current_state
  end

  def client_disconnected
    puts 'client disconnected'
  end
  
  def flip_tile_request
    puts 'tile flip requested'
    puts @table
    puts @table.to_h
    if current_user.request_flip!
      puts 'tile flip succeeded'
      broadcast_message :new_move, @table.to_h, namespace: :game_event
    else
      puts 'tile flip failed'
    end
  end

  def build_request
    puts 'build submitted'
    #current_user.submit_build()
  end

  def morph_request
    puts 'morph submitted'
    #current_user.submit_build()
  end
end
