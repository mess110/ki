DialogController = ($scope, $mdDialog, $localStorage, $mdToast) ->
  # $scope.user =
    # api_key: 'guest'
    # secret: 'guest'

  $scope.hide = ->
    $mdDialog.hide()
    return

  $scope.cancel = ->
    $mdDialog.cancel()
    return

  $scope.showToast = (s) ->
    toast = $mdToast.simple().content(s).position('bottom right').hideDelay(3000)
    $mdToast.show toast

  $scope.answer = () ->
    jNorthPole.getUser($scope.user, (data) ->
      json = data[0]
      exists = (item for item in $localStorage.accounts when item.api_key == json.api_key)
      if exists.length == 0
        $localStorage.accounts.push
          api_key: json.api_key
          secret: json.secret
        $mdDialog.hide 'refresh'
      else
        $scope.showToast "account already connected"
        console.log "account already connected"
    , (error) ->
      console.log error
      $scope.showToast error.error
    )
    return

  return

MainController = ($scope, userService, $mdSidenav, $mdBottomSheet, $log, $q, $mdDialog, $localStorage, $location, $mdToast) ->
  self = this

  toggleList = ->
    pending = $mdBottomSheet.hide() or $q.when(true)
    pending.then ->
      $mdSidenav('left').toggle()
      return
    return

  selectUser = (user) ->
    $localStorage.selected = angular.copy(user)
    $location.path "/blobs/#{user.api_key}"
    self.toggleList()
    return

  $scope.showToast = (s) ->
    toast = $mdToast.simple().content(s).position('bottom right').hideDelay(3000)
    $mdToast.show toast

  showAdvanced = (ev) ->
    $mdDialog.show(
      controller: DialogController
      templateUrl: 'js/templates/dialog1.tmpl.html'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true)
    .then ((answer) ->
      if answer == 'refresh'
        refresh()
      return
    ), ->
      # $scope.status = 'You cancelled the dialog.'
      return
    return


  self.selected = null
  self.users = []
  self.selectUser = selectUser
  self.toggleList = toggleList
  self.showAdvanced = showAdvanced

  refresh = ->
    userService.loadAllUsers().then (users) ->
      self.users = [].concat(users)
      return

  refresh()

  return

angular.module('app').controller 'MainController', ['$scope', 'userService', '$mdSidenav', '$mdBottomSheet', '$log', '$q', '$mdDialog', '$localStorage', '$location', '$mdToast', MainController]
