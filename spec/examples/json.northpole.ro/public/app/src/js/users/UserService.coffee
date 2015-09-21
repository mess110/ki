UserService = ($q, $localStorage) ->
  unless $localStorage.accounts?
    $localStorage.accounts = []

  users = $localStorage.accounts

  {
    loadAllUsers: ->
      $q.when users
  }

angular.module('users').service 'userService', ['$q', '$localStorage', UserService]
