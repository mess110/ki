$(() ->
  $.material.init()
)

app = angular.module('app', [])

app.directive 'specialInput', ->
  (scope, element, attrs) ->
    element.bind 'keypress', (event) ->
      # if event.which == 13
        # i = scope.result.caret.get
        # scope.result.text = scope.result.text.insert(i, "\n# ")
        # if scope.result.text.lineStartsWith(i)
          # scope.result.caret.set = i + 3
      return
    return

app.directive 'elastic', [
  '$timeout'
  ($timeout) ->
    {
      restrict: 'A'
      link: ($scope, element) ->
        $scope.initialHeight = $scope.initialHeight or element[0].style.height

        resize = ->
          element[0].style.height = $scope.initialHeight
          element[0].style.height = '' + element[0].scrollHeight + 'px'
          return

        element.on 'input change', resize
        $timeout resize, 0
        return

    }
]

app.controller 'MainCtrl', ($scope) ->

  $scope.resetJson = ->
    $scope.json =
      'api_key': 'guest'
      'secret': 'guest'
      'category': CATEGORY

  $scope.refresh = ->
    jNorthPole.getStorage $scope.json, (data) ->
      if $scope.json.apiKey != 'guest' and !data.error?
        localStorage.json = angular.toJson($scope.json)
      unless data.error? and data.api_key != 'guest'
        $scope.apiKey = $scope.json.apiKey
        $scope.results = data
        $scope.loggedIn = true
        $scope.$apply()
      return

  $scope.toggleAuth = ->
    if $scope.loggedIn
      $scope.loggedIn = false
      $scope.results = []
      localStorage.clear()
      $scope.resetJson()
    else
      $scope.loggedIn = false
      $scope.refresh()

    return

  log = (data) ->
    console.log "Saved #{data.id}"
    return

  $scope.save = (json) ->
    json.secret = $scope.json.secret
    json = angular.copy(json)

    if json.text == '/delete'
      delete json.priority
      delete json.text
      jNorthPole.deleteStorage json, -> {}

      for r in $scope.results
        if r.id == json.id
          $scope.results.splice $scope.results.indexOf(r), 1
          break
      return

    if json.id?
      jNorthPole.putStorage json, log
    else
      json.api_key = $scope.json.api_key
      json.category = CATEGORY
      jNorthPole.createStorage json, (data) ->
        $scope.results.push data
        $scope.$apply()
    return

  $scope.vote = (json, up=true)->
    if up
      json.priority += 1
    else
      json.priority -= 1
    $scope.save(json)

  $scope.newPanel = ->
    $scope.save(
      priority: $scope.results.length + 1
      text: 'mind'
      category: CATEGORY
    )
    return

  CATEGORY = 'mind'
  jNorthPole.BASE_URL = 'https://json.northpole.ro/'
  $scope.results = []
  if localStorage.json == undefined
    $scope.resetJson()
  else
    $scope.json = angular.fromJson(localStorage.json)
    $scope.toggleAuth()
