class ChatController < WebsocketRails::BaseController
  def initialize_session
    # run when a socket is set up
    puts 'session initialized'
  end

  def client_connected
      puts 'client connected'
      send_message :server_msg, {message: 'Client Connected'}
  end

  def client_disconnected
      puts 'client disconnected'
      send_message :server_msg, {message: 'Client Disconnected'}
  end
  
  def chat_sent
      puts 'client message sent'
      send_message :server_msg, {message: 'chat sent'}
  end
end
