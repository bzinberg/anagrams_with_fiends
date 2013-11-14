# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    dispatcher = new WebSocketRails("localhost:3000/websocket")

    dispatcher.on_open = (data) ->
        console.log "Connection established: #{data}"

    sendchatsuccess = (message) ->
            console.log('received' + message)
            $('#log').append($('<div/>').html(message['message']))

    sendchatfailure = (message) ->
            console.log('failure!' + message)

    $('#send_chat').on 'click', () ->
        console.log "send!"
        dispatcher.trigger 'chat_sent', $('#sendbox').val(), sendchatsuccess, sendchatfailure

        $('#sendbox').val('')

    dispatcher.bind 'chats.server_msg', (message) ->
        console.log(message)
        $('#log').append($('<div/>').html(message))
