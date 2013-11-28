class GameEventController < WebsocketRails::BaseController
  def initialize_session
    # run when a socket is set up
    puts 'session initialized'
  end

  def client_connected
    puts 'client connected'
    send_channel_msg(:new_state, @table.to_h)
  end

  def client_disconnected
    puts 'client disconnected'
  end

  def send_channel_msg(ev, msg)
    puts 'sending channel msg'
    WebsocketRails[@table.uuid].trigger(ev, msg, namespace: :game_event)
  end

  def state_request
    @table = current_user.table
    puts 'state requested'
    send_channel_msg(:new_state, @table.to_h)
  end
  
  def flip_tile_request
    @table = current_user.table
    puts 'tile flip requested'
    puts "message: #{message}"
    if current_user.request_flip!(message[:turn_number].to_i)
      puts 'tile flip succeeded'
      send_channel_msg(:new_state, @table.to_h)
    else
      puts 'tile flip failed (or, not everyone has requested a flip for the next turn)'
      # Actually, how can a client even get out of sync?  Unless we have bugs, this is impossible
    end
    puts 'flip_tile_request done'
  end

  def build_request
    @table = current_user.table
    @table.fiends.reload
    puts "build submitted: #{message[:word]}"
    if current_user.submit_build(message[:word].to_s)
      puts 'build request succeeded'
      send_channel_msg(:new_state, @table.to_h)
    else
      puts 'build request failed'
      send_channel_msg(:illegal_move, 'Failed build')
    end
  end

  def morph_request
    @table = current_user.table
    message[:changed_turn_number] ||= -1
    message[:word] ||= ''
    changed_turn_number = message[:changed_turn_number]
    @table.turns.reload
    changed_turn = @table.turns.exists?(turn_number: changed_turn_number) ? @table.turns.find_by_turn_number(changed_turn_number) : nil
    word = message[:word]
    puts "morph submitted: #{changed_turn_number}, #{word}"
    if changed_turn and current_user.submit_morph(changed_turn, word)
      puts 'Successful morph request'
      send_channel_msg(:new_state, @table.to_h)
    else
      puts 'Failed morph request'
      send_channel_msg(:illegal_move, 'Failed morph')
    end
  end
end
