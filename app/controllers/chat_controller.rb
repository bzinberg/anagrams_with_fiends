class ChatController < WebsocketRails::BaseController
  def initialize_session
    # run when a socket is set up
    puts 'session initialized'
  end

  def client_connected
      puts 'client connected'
      m = {message: 'Client Connected'}
      send_message :server_msg, m
  end

  def client_disconnected
      puts 'client disconnected'
      m = {message: 'Client Disconnected'}
      send_message :server_msg, m
  end
  
  def chat_sent
      puts 'client message sent'
      m = {message: message[:val]}
      send_message :server_msg, m
  end
end
