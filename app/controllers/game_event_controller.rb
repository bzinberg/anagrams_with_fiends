class GameEventController < WebsocketRails::BaseController
  before_action :set_table

  def initialize_session
    # run when a socket is set up
    puts 'session initialized'
  end

  def client_connected
    puts 'client connected'
    send_message :connect
  end

  def client_disconnected
    puts 'client disconnected'
  end

  def state_request
    @table = current_user.table
    puts 'state requested'
    broadcast_message :new_state, @table.to_h, namespace: :game_event
  end
  
  def flip_tile_request
    @table = current_user.table
    puts 'tile flip requested'
    puts 'current_user.table: ' + current_user.table.uuid
    puts '@table: ' + @table.uuid
    puts "message: #{message}"
    if current_user.request_flip!(message.to_i)
      puts 'tile flip succeeded'
      broadcast_message :new_state, current_user.table.to_h, namespace: :game_event
    else
      puts 'tile flip failed (or, not everyone has requested a flip for the next turn)'
    end
    puts 'flip_tile_request done'
  end

  def build_request
    puts 'build submitted'
    #current_user.submit_build()
  end

  def morph_request
    puts 'morph submitted'
    #current_user.submit_build()
  end

  private
    def set_table
      @table = current_user.table
    end
end
