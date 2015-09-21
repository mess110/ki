var DialogController, MainController;

DialogController = function($scope, $mdDialog, $localStorage, $mdToast) {
  var apiError, userFound;
  $scope.hide = function() {
    $mdDialog.hide();
  };
  $scope.cancel = function() {
    $mdDialog.cancel();
  };
  $scope.showToast = function(s) {
    var toast;
    toast = $mdToast.simple().content(s).position('bottom right').hideDelay(3000);
    return $mdToast.show(toast);
  };
  apiError = function(error) {
    console.log(error);
    return $scope.showToast(error.error);
  };
  userFound = function(json) {
    $localStorage.accounts.push({
      api_key: json.api_key,
      secret: json.secret
    });
    return $mdDialog.hide('refresh');
  };
  $scope.register = function() {
    jNorthPole.createUser($scope.user.api_key, $scope.user.secret, userFound, apiError);
  };
  $scope.connect = function() {
    jNorthPole.getUser($scope.user, function(data) {
      var exists, item, json;
      json = data[0];
      exists = (function() {
        var i, len, ref, results;
        ref = $localStorage.accounts;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          item = ref[i];
          if (item.api_key === json.api_key) {
            results.push(item);
          }
        }
        return results;
      })();
      if (exists.length === 0) {
        return userFound(json);
      } else {
        $scope.showToast("account already connected");
        return console.log("account already connected");
      }
    }, apiError);
  };
};

MainController = function($scope, userService, $mdSidenav, $mdBottomSheet, $log, $q, $mdDialog, $localStorage, $location, $mdToast) {
  var refresh, selectUser, self, showAdvanced, toggleList;
  self = this;
  toggleList = function() {
    var pending;
    pending = $mdBottomSheet.hide() || $q.when(true);
    pending.then(function() {
      $mdSidenav('left').toggle();
    });
  };
  selectUser = function(user) {
    $localStorage.selected = angular.copy(user);
    $location.path("/blobs/" + user.api_key);
    self.toggleList();
  };
  $scope.showToast = function(s) {
    var toast;
    toast = $mdToast.simple().content(s).position('bottom right').hideDelay(3000);
    return $mdToast.show(toast);
  };
  showAdvanced = function(ev) {
    $mdDialog.show({
      controller: DialogController,
      templateUrl: 'js/templates/dialog1.tmpl.html',
      parent: angular.element(document.body),
      targetEvent: ev,
      clickOutsideToClose: true
    }).then((function(answer) {
      if (answer === 'refresh') {
        refresh();
      }
    }), function() {});
  };
  self.selected = null;
  self.users = [];
  self.selectUser = selectUser;
  self.toggleList = toggleList;
  self.showAdvanced = showAdvanced;
  refresh = function() {
    return userService.loadAllUsers().then(function(users) {
      self.users = [].concat(users);
    });
  };
  refresh();
};

angular.module('app').controller('MainController', ['$scope', 'userService', '$mdSidenav', '$mdBottomSheet', '$log', '$q', '$mdDialog', '$localStorage', '$location', '$mdToast', MainController]);
