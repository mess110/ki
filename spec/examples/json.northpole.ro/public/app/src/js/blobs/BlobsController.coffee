BlobsController = ($scope, $routeParams, $location, $localStorage, $mdBottomSheet) ->
  if !$routeParams.id? and $localStorage.selected?
    $location.path "/blobs/#{$localStorage.selected.api_key}"
    return

  $scope.fullItem = null

  if $routeParams.id?
    unless $localStorage.selected?
      $location.path '/blobs'
      return

    $scope.user = $localStorage.selected
    jNorthPole.getStorage($scope.user, (data) ->
      $scope.items = data.reverse()
      $scope.$apply()
    , (error) ->
      console.log error
    )
  else
    $location.path '/tutorial'
    return

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

  $scope.addItemToList = (item, s) ->
    return if s == ''
    item.list = [] unless item.list?
    item.list.push { checked: false, text: s }
    $scope.save(item)

  $scope.removeItemFromList = (item, listItem) ->
    index = item.list.indexOf(listItem)
    item.list.splice(index, 1)
    $scope.save(item)

  $scope.fullscreen = (item) ->
    if $scope.fullItem?
      $scope.fullItem = null
    else
      $scope.fullItem = item

  $scope.toggleType = (item) ->
    if item.type == 'list'
      item.type = 'text'
    else
      item.type = 'list'
    $scope.save(item)

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
        $scope.items.unshift data
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
          name: 'Yes, delete already'
          icon: 'delete'
        }
      ]

      @submitContact = (action) ->
        $mdBottomSheet.hide action
        return

      return

    $mdBottomSheet
      .show(
        parent: angular.element(document.body)
        templateUrl: './js/templates/contactSheet.html'
        controller: ['$mdBottomSheet', '$scope', ContactPanelController]
        controllerAs: 'cp'
        bindToController: true
        targetEvent: $event)
      .then (clickedItem) ->
        if clickedItem.icon == 'delete'
          $scope.delete(json)
        return

  return

angular.module('users').controller 'BlobsController', ['$scope', '$routeParams', '$location', '$localStorage', '$mdBottomSheet', BlobsController]
