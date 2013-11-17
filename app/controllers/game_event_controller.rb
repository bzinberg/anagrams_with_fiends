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
      broadcast_message :new_state, @table.to_h, namespace: :game_event
    else
      puts 'tile flip failed (or, not everyone has requested a flip for the next turn)'
      # TODO Instead of being a public info message, it should be a private state message.
      # How to have private channel between server and a single client?
      # broadcast_message :next_turn_number, @table.next_turn_number, namespace: :game_info
      #
      # Actually, how can a client even get out of sync?  Unless we have bugs, this is impossible
    end
    puts 'flip_tile_request done'
  end

  def build_request
    @table = current_user.table
    @table.fiends.reload
    puts "build submitted: #{message}"
    if current_user.submit_build(message.to_s)
      puts 'hmm no issue'
      broadcast_message :new_state, @table.to_h, namespace: :game_event
    else
      puts 'hmm some issue'
    end
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
