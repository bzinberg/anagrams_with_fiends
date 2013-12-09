class GameEventController < WebsocketRails::BaseController
  def initialize_session
    # run when a socket is set up
  end

  def client_connected
    send_channel_msg(:new_state, @table.to_h)
  end

  def client_disconnected
  end

  def send_channel_msg(ev, msg)
    WebsocketRails[@table.uuid].trigger(ev, msg, namespace: :game_event)
  end

  def state_request
    @table = current_user.table
    send_channel_msg(:new_state, @table.to_h)
  end
  
  def flip_tile_request
    @table = current_user.table
    if current_user.request_flip!(message[:turn_number].to_i)
      send_channel_msg(:new_state, @table.to_h)
    else
      # Actually, how can a client even get out of sync?  Unless we have bugs, this is impossible
    end
  end

  def build_request
    @table = current_user.table
    @table.fiends.reload
    if current_user.submit_build(message[:word].to_s)
      send_channel_msg(:new_state, @table.to_h)
    else
      send_channel_msg(:illegal_move, {failmsg: "You can't build the word '#{message[:word].downcase}'!", username: current_user.username} )
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
    if changed_turn and current_user.submit_morph(changed_turn, word)
      send_channel_msg(:new_state, @table.to_h)
    else
      send_channel_msg(:illegal_move, {failmsg: "You can't morph the word '#{message[:word].downcase}'!", username: current_user.username} )
    end
  end
end
