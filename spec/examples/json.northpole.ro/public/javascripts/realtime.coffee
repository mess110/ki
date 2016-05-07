$(document).ready ->
  output = $('.realtime-output')
  return if output.length <= 0

  socket = jNorthPole.getNewRealtimeSocket((data) ->
    console.log data
    return unless data.data?
    json = JSON.parse(data.data)
    if json.messages?
      txt = (json.messages.map (e) -> e.content.message).join(' - ')
      output.text(txt)
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
