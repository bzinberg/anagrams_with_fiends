state = @table.current_state
# TODO This info is sufficient for the MVP, where each table has only one
# fiend.
json.next_turn_number table.next_turn_number
stashes_to_send = @table.stashes.map do |user,turns|
  [user.username, turns.to_a.map{|turn| turn.word}] 
end
json.stashes Hash[stashes_to_send]
