# Author: Damien

class ChannelAuthorizationController < WebsocketRails::BaseController
  def authorize_channels
    # channel name is uuid of table
    channel_name = message[:channel]

    if current_user.table.uuid == channel_name
      accept_channel current_user
    else
      error_msg = {:message => "You can't access this table's channel!"}
      deny_channel error_msg
    end
  end
end
