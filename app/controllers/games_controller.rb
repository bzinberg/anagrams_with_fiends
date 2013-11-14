class GamesController < WebsocketRails::BaseController
  def initialize_session
    # run when a socket is set up
    puts 'session initialized'
  end

  def client_connected
      puts 'client connected'
      broadcast_message :server_msg, {message: 'Client Connected'}
  end

  def client_disconnected
      puts 'client disconnected'
      broadcast_message :server_msg, {message: 'Client Disconnected'}
  end
  
  def chat_sent(message)
      puts 'client connected'
      broadcast_message :server_msg, {message: message}
  end
end
