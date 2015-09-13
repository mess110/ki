$(() ->
  $.material.init()
)

app = angular.module('app', [ 'youtube-embed' ])

app.controller 'MainCtrl', ($scope, youtubeEmbedUtils) ->

  $scope.refresh = ->
    if $scope.loggedIn
      $scope.loggedIn = false
      $scope.results = []
      localStorage.clear()
      $scope.json =
        'api_key': 'guest'
        'secret': 'guest'
        'category': 'music'
    else
      $scope.loggedIn = false
      jNorthPole.getStorage $scope.json, (data) ->
        if $scope.json.apiKey != 'guest' and !data.error?
          localStorage.json = angular.toJson($scope.json)
        unless data.error? and data.api_key != 'guest'
          $scope.apiKey = $scope.json.apiKey
          $scope.results = data
          $scope.loggedIn = true
          $scope.$apply()
        return

    return

  jNorthPole.BASE_URL = 'https://json.northpole.ro/'
  $scope.results = []
  $scope.playerVars =
    controls: 1
    autoplay: 1
  if localStorage.json == undefined
    $scope.json =
      'api_key': 'guest'
      'secret': 'guest'
      'category': 'music'
  else
    $scope.json = angular.fromJson(localStorage.json)
    $scope.refresh()

  $scope.play = (video) ->
    return unless video?
    if $scope.ytVideoUrl == video.url and $scope.bestPlayer? and $scope.bestPlayer.getPlayerState() == 1
      $scope.bestPlayer.pauseVideo()
    else
      $scope.ytVideoUrl = video.url
      $scope.bestPlayer.playVideo() if $scope.bestPlayer?
      # console.log youtubeEmbedUtils.getIdFromURL($scope.ytVideoUrl)
    return

  $scope.edit = (video) ->
    $scope.selected = video
    return

  $scope.save = (video) ->
    $scope.selected.secret = $scope.json.secret
    json = angular.copy($scope.selected)

    log = (data) ->
      console.log data
      return

    if video.id?
      jNorthPole.putStorage json, log
    else
      json.api_key = $scope.json.api_key
      json.category = 'music'
      jNorthPole.createStorage json, log
    $('#complete-dialog').modal('hide')
    $scope.selected = undefined
    return

  $scope.newSong = ->
    $scope.selected = {}
    return

  $scope.select = (json) ->
    $scope.selected = json
    return

  $scope.isSelected = (video) ->
    $scope.ytVideoUrl == video.url

  $scope.playRandom = ->
    item = $scope.results[Math.floor(Math.random() * $scope.results.length)]
    $scope.play item
    if player?
      player.seekTo 0
    return

  $scope.$on 'youtube.player.ended', ($event, player) ->
    $scope.playRandom player
    return
  return
