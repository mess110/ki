MusicController = ($scope, $routeParams, $location, $localStorage) ->
  # TODO: duplicate code with BlobController
  if !$routeParams.id? and $localStorage.selected?
    $location.path "/music/#{$localStorage.selected.api_key}"
    return

  if $routeParams.id?
    unless $localStorage.selected?
      $location.path '/music'
      return

    $scope.user = $localStorage.selected
    jNorthPole.getStorage($scope.user, (data) ->
      $scope.items = data
      $scope.$apply()
    , (error) ->
      console.log error
    )
  else
    $location.path '/tutorial'
    return

  $scope.playerVars =
    controls: 1
    autoplay: 1
  $scope.ytVideoUrl = 'https://www.youtube.com/watch?v=DcHKOC64KnE'

angular.module('users').controller 'MusicController', ['$scope', '$routeParams', '$location', '$localStorage', '$mdBottomSheet', MusicController]
