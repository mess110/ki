$(document).ready ->
  output = $('.realtime-output')
  return if output.length <= 0

  socket = jNorthPole.getNewRealtimeSocket((data) ->
    return unless data.data?
    json = JSON.parse(data.data)
    # if json.type == 'publish'
      # console.log json
    output.text(JSON.stringify(json.messages))
  )
  setTimeout ->
    jNorthPole.subscribe(socket, 'jNorthPoleChat')
  , 2000

  $('.realtime-input').keypress((event) ->
    keycode = if event.keyCode then event.keyCode else event.which
    if (keycode == 13)
      inptz = $(@)
      jNorthPole.publish(socket, 'jNorthPoleChat', { message: inptz.val() })
  )
