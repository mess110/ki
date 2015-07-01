throw 'jQuery library missing' unless window.jQuery

window.jNorthPole =

  BASE_URL: '/'

  help: ->
    console.log """
NorthPole js library - requires jQuery

Example usage:

Vanilla JS:

  responseHandler = function (data) {
    console.log(data);
  };

  jNorthPole.BASE_URL = '/';
  jNorthPole.getStorage(json, responseHandler);

CoffeeScript:

  responseHandler = (data) ->
    console.log data

  jNorthPole.BASE_URL = '/'
  jNorthPole.getStorage(json, responseHandler)
"""

  genericRequest: (jsonObj, method, endPoint, responseHandler, errorHandler=responseHandler) ->
    throw 'responseHandler function missing' unless responseHandler?

    $.ajax
      type: method
      url: "#{@BASE_URL}#{endPoint}.json"
      data: JSON.stringify(jsonObj)
      success: (data, textStatus, jqXHR) ->
        # TODO: parse data as JSON
        responseHandler(data)
      error: (jqXHR, textstatus, errorthrown) ->
        console.log(jqXHR.responseText)
        errorHandler(JSON.parse(jqXHR.responseText))

  createUser: (api_key, secret, success, failure) ->
    jsonObj = {'api_key': api_key, 'secret': secret}
    @genericRequest(jsonObj, 'POST', 'user', success, failure)

  createStorage: (jsonObj, responseHandler, errorHandler=responseHandler) ->
    @genericRequest(jsonObj, 'POST', 'storage', responseHandler, errorHandler)

  putStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'PUT', 'storage', responseHandler, errorHandler)

  getStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'SEARCH', 'storage', responseHandler, errorHandler)

  deleteStorage: (jsonObj, responseHandler, errorHandler) ->
    @genericRequest(jsonObj, 'DELETE', 'storage', responseHandler, errorHandler)
