var UserService;

UserService = function($q, $localStorage) {
  var users;
  if ($localStorage.accounts == null) {
    $localStorage.accounts = [];
  }
  users = $localStorage.accounts;
  return {
    loadAllUsers: function() {
      return $q.when(users);
    }
  };
};

angular.module('users').service('userService', ['$q', '$localStorage', UserService]);
