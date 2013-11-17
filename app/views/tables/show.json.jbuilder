# TODO this code isn't used anymore; delete it if necessary
# TODO This info is sufficient for the MVP, where each table has only one
# fiend.
json.next_turn_number @table.next_turn_number
state = @table.current_state
stashes_to_send = state.stashes.map do |user,turns|
  [user.username, turns.to_a.map{|turn| [turn.turn_number, turn.word]}] 
end
json.stashes Hash[stashes_to_send]
json.pool state.pool
json.bag_size state.bag.size
