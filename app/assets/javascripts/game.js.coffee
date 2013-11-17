# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

state =
    bag_size: 3,
    pool: "abcdefg",
    stashes: {
        'leon': [[3, 'lfoel'], [1, 'guacamolee'], [2, 'heloe']],
        'aaa': [[3, 'lkhoel'], [1, 'guacamoleeeee'], [2, 'heloe']]
    }

initSocket = () ->
    alert('socket init')
    turn_number = 0

    dispatcher = new WebSocketRails("localhost:3000/websocket")

    dispatcher.on_open = (data) ->
        console.log "Connection established: " + JSON.stringify(data)

    $('#flip_tile').on 'click', () ->
        console.log "tile flip requested!"
        dispatcher.trigger 'table.flip_tile_request'

    dispatcher.bind 'connect', (response) ->
        alert('connected!')
        $('#gamelog').append($('<div/>').html(response))
        updateAll(response)

    dispatcher.bind 'game_event.new_move', (response) ->
        alert('new move!')
        $('#gamelog').append($('<div/>').html(response))
        updateAll(response)
        #console.log(response)
        #$('#gamelog').append($('<div/>').html(response.message))

updateAll = (state) ->
    updateBag(state)
    updatePool(state)
    updateStashes(state)

updateBag = (state) ->
    console.log("updating bag")
    $bagBox = $('#bagBox')
    $bagBox.html(state.bag_size)

appendLetter = ($elt, letter) ->
    $elt.append('<img src="assets/tiles/' + letter + '.png" width="40" height="40" hspace="1">')

updatePool = (state) ->
    console.log("updating pool")
    $poolDiv = $('#poolDiv')
    $poolDiv.html('')
    letters = state.pool
    i = 0
    letters.split("").forEach((letter) ->
        if (i%10==0)
            $poolDiv.append("<br>")
        i++
        appendLetter($poolDiv, letter)
    )

updateSingleStash = (stashName) ->
    $stashDiv = findStashDivByName(stashName)
    $stashDiv.html('')

    state.stashes[stashName].forEach((entry) ->
        $wordDiv = $("<div>").attr('turnNumber', entry[0])
        entry[1].split('').forEach((letter) ->
            appendLetter($stashDiv, letter)
        )
        $stashDiv.append($wordDiv)
    )

updateStashes = (state) ->
    console.log("updating stashes")
    updateSingleStash(name) for name, words of state.stashes

findStashDivByName = (name) ->
    return $("#stashDiv")

onready = () ->
    initSocket()
    state.stashes[fiend].sort((pair1, pair2) ->
      return pair1[0] - pair2[0]
    ) for fiend in state.stashes
    updateAll(state)


$ -> onready()
