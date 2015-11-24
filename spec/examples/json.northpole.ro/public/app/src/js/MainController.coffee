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

  apiError = (error) ->
    console.log error
    $scope.showToast error.error

  userFound = (json) ->
    $localStorage.accounts.push
      api_key: json.api_key
      secret: json.secret
    $mdDialog.hide 'refresh'

  $scope.register = () ->
    jNorthPole.createUser($scope.user.api_key, $scope.user.secret, userFound, apiError)
    return

  $scope.connect = () ->
    jNorthPole.getUser($scope.user, (data) ->
      json = data[0]
      exists = (item for item in $localStorage.accounts when item.api_key == json.api_key)
      if exists.length == 0
        userFound(json)
      else
        $scope.showToast "account already connected"
        console.log "account already connected"
    , apiError)
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
    refresh()
    return

  $scope.showToast = (s) ->
    toast = $mdToast.simple().content(s).position('bottom right').hideDelay(3000)
    $mdToast.show toast

  $scope.fortune = ->
    # http://www.chinese-fortune-cookie.com/fortune-cookie-quotes.html
    fortunes = [
      'There is a true and sincere friendship between you and your friends.'
      'You find beauty in ordinary things, do not lose this ability.'
      'Ideas are like children; there are none so wonderful as your own.'
      'It takes more than good memory to have good memories.'
      'A thrilling time is in your immediate future.'
      'Your blessing is no more than being safe and sound for the whole lifetime.'
      'Plan for many pleasures ahead.'
      'The joyfulness of a man prolongeth his days.'
      'Your everlasting patience will be rewarded sooner or later.'
      'Make two grins grow where there was only a grouch before.'
      'Something you lost will soon turn up.'
      'Your heart is pure, and your mind clear, and your soul devout.'
      'Excitement and intrigue follow you closely wherever you go!'
      'A pleasant surprise is in store for you.'
      'May life throw you a pleasant curve.'
      'As the purse is emptied the heart is filled.'
      'Be mischievous and you will not be lonesome.'
      'You have a deep appreciation of the arts and music.'
      'Your flair for the creative takes an important place in your life.'
      'Your artistic talents win the approval and applause of others.'
      'Pray for what you want, but work for the things you need.'
      'Your many hidden talents will become obvious to those around you.'
      'Don\'t forget, you are always on our minds.'
      'Your greatest fortune is the large number of friends you have.'
      'A firm friendship will prove the foundation on your success in life.'
      'Don\'t ask, don\'t say. Everything lies in silence.'
      'Look for new outlets for your own creative abilities.'
      'Be prepared to accept a wondrous opportunity in the days ahead!'
      'Fame, riches and romance are yours for the asking.'
      'Good luck is the result of good planning.'
      'Good things are being said about you.'
      'Smiling often can make you look and feel younger.'
      'Someone is speaking well of you.'
      'The time is right to make new friends.'
      'You will inherit some money or a small piece of land.'
      'Your life will be happy and peaceful.'
      'A friend is a present you give yourself.'
      'A member of your family will soon do something that will make you proud.'
      'A quiet evening with friends is the best tonic for a long day.'
      'A single kind word will keep one warm for years.'
      'Anger begins with folly, and ends with regret.'
      'Generosity and perfection are your everlasting goals.'
      'Happy news is on its way to you.'
      'He who laughs at himself never runs out of things to laugh at.'
      'If your desires are not extravagant they will be granted.'
      'Let there be magic in your smile and firmness in your handshake.'
      'If you want the rainbow, you must to put up with the rain. D. Parton'
      'Nature, time and patience are the three best physicians.'
      'Strong and bitter words indicate a weak cause.'
      'The beginning of wisdom is to desire it.'
      'You will have a very pleasant experience.'
      'You will inherit some money or a small piece of land.'
      'You will live a long, happy life.'
      'You will spend old age in comfort and material wealth.'
      'You will step on the soil of many countries.'
      'You will take a chance in something in the near future.'
      'You will witness a special ceremony.'
      'Your everlasting patience will be rewarded sooner or later.'
      'Your great attention to detail is both a blessing and a curse.'
      'Your heart is a place to draw true happiness.'
      'Your ability to juggle many tasks will take you far.'
      'A friend asks only for your time, not your money.'
      'You will be invited to an exciting event.'
    ]
    $scope.showToast(fortunes[Math.floor(Math.random()*fortunes.length)])

  showAdvanced = (ev) ->
    $mdDialog.show(
      controller: DialogController
      templateUrl: 'js/templates/dialog1.tmpl.html'
      parent: angular.element(document.body)
      targetEvent: ev
      clickOutsideToClose: true)
    .then ((answer) ->
      refresh() if answer == 'refresh'
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
      $scope.user = $localStorage.selected if $localStorage.selected?
      return

  refresh()
  return

angular.module('app').controller 'MainController', ['$scope', 'userService', '$mdSidenav', '$mdBottomSheet', '$log', '$q', '$mdDialog', '$localStorage', '$location', '$mdToast', MainController]
