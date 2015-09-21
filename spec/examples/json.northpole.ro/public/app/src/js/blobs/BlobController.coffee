BlobController = ($scope, $routeParams, $location, $localStorage, $mdBottomSheet) ->
  if !$routeParams.id? and $localStorage.selected?
    $location.path "/blobs/#{$localStorage.selected.api_key}"
    return

  if $routeParams.id?
    $scope.user = $localStorage.selected
    jNorthPole.getStorage($scope.user, (data) ->
      $scope.items = data
      $scope.$apply()
    , (error) ->
      console.log error
    )
  else
    console.log 'nothing to see here'

  $scope.delete = (item) ->
    item = angular.copy(item)
    item.secret = $scope.user.secret

    jNorthPole.deleteStorage(item, (data) ->
      for r in $scope.items
        if r.id == item.id
          $scope.items.splice $scope.items.indexOf(r), 1
          break
      $scope.$apply()
    , (error) ->
      console.log error
    )
    return

  $scope.save = (item) ->
    item = angular.copy(item)
    item.api_key = $scope.user.api_key
    item.secret = $scope.user.secret

    callback = (data) ->
      console.log data

    if item.id?
      jNorthPole.putStorage(item, callback)
    else
      jNorthPole.createStorage(item, (data) ->
        $scope.items.push data
        $scope.$apply()
      , callback)

  $scope.newPanel = ->
    $scope.save(text: '')

  $scope.showContactOptions = ($event, json) ->
    json = angular.copy(json)

    ContactPanelController = ($mdBottomSheet, $scope) ->
      @json = json
      @actions = [
        {
          name: 'Delete'
          icon: 'delete'
        }
      ]

      @submitContact = (action) ->
        $mdBottomSheet.hide action
        return

      return

    $mdBottomSheet
      .show(
        parent: angular.element(document.getElementById('content'))
        templateUrl: './js/users/contactSheet.html'
        controller: ['$mdBottomSheet', '$scope', ContactPanelController]
        controllerAs: 'cp'
        bindToController: true
        targetEvent: $event)
      .then (clickedItem) ->
        if clickedItem.name == 'Delete'
          $scope.delete(json)
        return

  return

angular.module('users').controller 'BlobController', ['$scope', '$routeParams', '$location', '$localStorage', '$mdBottomSheet', BlobController]
