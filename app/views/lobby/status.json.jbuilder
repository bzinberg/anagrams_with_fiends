json.you_user current_user.username

json.online_users Hash[User.online.map{|u| [u.username, u.rank]}]

if current_user.outgoing_challenge.nil?
  json.outgoing_challenge nil
else
  c = current_user.outgoing_challenge
  json.outgoing_challenge do |x|
    x.username c.challengee.username
    x.accepted c.accepted
  end
end

json.incoming_challenges Hash[current_user.incoming_challenges.where(accepted: [nil, true]).map{|c| [c.challenger.username, c.challenger.rank]}]
