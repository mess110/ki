$(document).ready ->
  receivedMessages = []

  output = $('.realtime-output')
  return if output.length <= 0

  socket = jNorthPole.getNewRealtimeSocket((data) ->
    console.log data
    return unless data.data?
    json = JSON.parse(data.data)
    return unless json.messages?

    for message in json.messages
      if $.inArray(message.id, receivedMessages) == -1
        receivedMessages.push(message.id)
        output.append("#{message.content.message}<br />")
  )
  setTimeout ->
    jNorthPole.subscribe(socket, 'jNorthPoleChat')
  , 2000

  $('.realtime-input').keypress((event) ->
    keycode = if event.keyCode then event.keyCode else event.which
    if (keycode == 13)
      inptz = $(@)
      jNorthPole.publish(socket, 'jNorthPoleChat', { message: inptz.val() })
      inptz.val('')
  )
