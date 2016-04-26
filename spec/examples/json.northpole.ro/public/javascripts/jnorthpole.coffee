window.jNorthPole =

  BASE_URL: 'https://json.northpole.ro/'

  help: """
    NorthPole JS wrapper example usage:

    responseHandler = function (data) {
      console.log(data);
    };

    jNorthPole.BASE_URL = '/';
    jNorthPole.getStorage(json, responseHandler);

    socket = jNorthPole.getNewRealtimeSocket(responseHandler)
    jNorthPole.subscribe(socket, 'foo')
    jNorthPole.publish(socket, 'foo', { message: 'hello' })
    """

  genericRequest: (jsonObj, method, endPoint, responseHandler, errorHandler=responseHandler) ->
    throw 'responseHandler function missing' unless responseHandler?

    r = new XMLHttpRequest
    r.open method, "#{@BASE_URL}#{endPoint}.json", true

    r.onreadystatechange = ->
      return if r.readyState != 4
      if r.status == 200
        responseHandler(JSON.parse(r.responseText), r.status)
      else
        errorHandler(JSON.parse(r.responseText), r.status)
      return
    r.send JSON.stringify(jsonObj)
    return

  createUser: (api_key, secret, success, failure) ->
    jsonObj = {'api_key': api_key, 'secret': secret}
    @genericRequest(jsonObj, 'POST', 'user', success, failure)
    return

  getUser: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'SEARCH', 'user', responseHandler, errorHandler)
    return

  createStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'POST', 'storage', responseHandler, errorHandler)
    return

  getStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'SEARCH', 'storage', responseHandler, errorHandler)
    return

  putStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'PUT', 'storage', responseHandler, errorHandler)
    return

  deleteStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'DELETE', 'storage', responseHandler, errorHandler)
    return

  getNewRealtimeSocket: (responseHandler, errorHandler=responseHandler) ->
    socketUrl = @BASE_URL.replace('https', 'wss')
    socket = new WebSocket("#{socketUrl}realtime")
    socket.onmessage = responseHandler
    socket.onclose = errorHandler
    socket

  subscribe: (socket, channel_name) ->
    socket.send(JSON.stringify(
      type: 'subscribe'
      channel_name: channel_name
    ))

  unsubscribe: (socket, channel_name) ->
    socket.send(JSON.stringify(
      type: 'unsubscribe'
      channel_name: channel_name
    ))

  publish: (socket, channel_name, json) ->
    socket.send(JSON.stringify(
      type: 'publish'
      channel_name: channel_name
      content: json
    ))
