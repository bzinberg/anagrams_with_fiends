# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    dispatcher = new WebSocketRails("localhost:3000/websocket")

    dispatcher.on_open = (data) ->
        console.log "Connection established: #{data}"

    sendchatsuccess = (response) ->
        console.log('received ' + response)
        $('#gamelog').append($('<div/>').html(response.message))

    sendchatfailure = (response) ->
        console.log('failure! ' + response)

    $('#send_chat').on 'click', () ->
        console.log "send!"
        message = {val: $('#sendbox').val()}
        dispatcher.trigger 'chat_sent', message

        $('#sendbox').val('')

    dispatcher.bind 'server_msg', (response) ->
        $('#gamelog').append($('<div/>').html(response.message))

        #console.log(response)
        #$('#gamelog').append($('<div/>').html(response.message))

