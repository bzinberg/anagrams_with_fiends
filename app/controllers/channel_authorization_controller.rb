class ChannelAuthorizationController < WebsocketRails::BaseController
  def authorize_channels
    # channel name is uuid of table
    channel_name = message[:channel]
    puts "trying to authorize #{current_user.username} to channel #{channel_name}"

    if current_user.table.uuid == channel_name
      puts "successfully authed to channel"
      accept_channel current_user
    else
      puts "failed to auth to channel"
      error_msg = {:message => "You can't access this table's channel!"}
      deny_channel error_msg
    end
  end
end
