window.jNorthPole =
  root: Math.sqrt,
  square: (x) -> x * x,
  cube: (x) -> x * this.square x,
  createUser: (api_key, secret, success, failer) ->
    jsonObj = {'api_key': api_key, 'secret': secret}
    $.ajax
      type: "POST"
      url: "/user.json"
      data: JSON.stringify(jsonObj)
      success: (data, textStatus, jqXHR) ->
        success()
      error: (jqXHR, textstatus, errorthrown) ->
        failer(jqXHR)
  genericRequest: (jsonObj, method, responseHandler) ->
    $.ajax
      type: method
      url: "/storage.json"
      data: JSON.stringify(jsonObj)
      success: (data, textStatus, jqXHR) ->
        responseHandler(data)
      error: (jqXHR, textstatus, errorthrown) ->
        console.log(jqXHR.responseText)
        responseHandler(JSON.parse(jqXHR.responseText))
  createStorage: (jsonObj, responseHandler) ->
    this.genericRequest(jsonObj, 'POST', responseHandler)
  putStorage: (jsonObj, responseHandler) ->
    this.genericRequest(jsonObj, 'PUT', responseHandler)
  getStorage: (jsonObj, responseHandler) ->
    this.genericRequest(jsonObj, 'SEARCH', responseHandler)
  deleteStorage: (jsonObj, responseHandler) ->
    this.genericRequest(jsonObj, 'DELETE', responseHandler)
  getUrl: (id) ->
    "http://localhost:9292/storage.json?id=" + id
