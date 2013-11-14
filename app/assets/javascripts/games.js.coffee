# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    dispatcher = new WebSocketRails("localhost:3000/websocket")

    dispatcher.on_open = (data) ->
        console.log "Connection established: #{data}"

    $('#send_chat').bind 'click', (message) ->
        dispatcher.trigger 'chat_sent', message

    dispatcher.bind 'server_msg', (message) ->
        console.log(message)
