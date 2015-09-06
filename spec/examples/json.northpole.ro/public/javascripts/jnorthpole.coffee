window.jNorthPole =

  BASE_URL: '/'

  help: """
    NorthPole JS wrapper example usage:

    responseHandler = function (data) {
      console.log(data);
    };

    jNorthPole.BASE_URL = '/';
    jNorthPole.getStorage(json, responseHandler);
    """

  genericRequest: (jsonObj, method, endPoint, responseHandler, errorHandler=responseHandler) ->
    throw 'responseHandler function missing' unless responseHandler?

    r = new XMLHttpRequest
    r.open method, "#{@BASE_URL}#{endPoint}.json", true

    r.onreadystatechange = ->
      return if r.readyState != 4
      if status == 200
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

  createStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'POST', 'storage', responseHandler, errorHandler)
    return

  putStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'PUT', 'storage', responseHandler, errorHandler)
    return

  getStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'SEARCH', 'storage', responseHandler, errorHandler)
    return

  deleteStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'DELETE', 'storage', responseHandler, errorHandler)
    return
