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
    refresh();
  };
  $scope.showToast = function(s) {
    var toast;
    toast = $mdToast.simple().content(s).position('bottom right').hideDelay(3000);
    return $mdToast.show(toast);
  };
  $scope.fortune = function() {
    var fortunes;
    fortunes = ['There is a true and sincere friendship between you and your friends.', 'You find beauty in ordinary things, do not lose this ability.', 'Ideas are like children; there are none so wonderful as your own.', 'It takes more than good memory to have good memories.', 'A thrilling time is in your immediate future.', 'Your blessing is no more than being safe and sound for the whole lifetime.', 'Plan for many pleasures ahead.', 'The joyfulness of a man prolongeth his days.', 'Your everlasting patience will be rewarded sooner or later.', 'Make two grins grow where there was only a grouch before.', 'Something you lost will soon turn up.', 'Your heart is pure, and your mind clear, and your soul devout.', 'Excitement and intrigue follow you closely wherever you go!', 'A pleasant surprise is in store for you.', 'May life throw you a pleasant curve.', 'As the purse is emptied the heart is filled.', 'Be mischievous and you will not be lonesome.', 'You have a deep appreciation of the arts and music.', 'Your flair for the creative takes an important place in your life.', 'Your artistic talents win the approval and applause of others.', 'Pray for what you want, but work for the things you need.', 'Your many hidden talents will become obvious to those around you.', 'Don\'t forget, you are always on our minds.', 'Your greatest fortune is the large number of friends you have.', 'A firm friendship will prove the foundation on your success in life.', 'Don\'t ask, don\'t say. Everything lies in silence.', 'Look for new outlets for your own creative abilities.', 'Be prepared to accept a wondrous opportunity in the days ahead!', 'Fame, riches and romance are yours for the asking.', 'Good luck is the result of good planning.', 'Good things are being said about you.', 'Smiling often can make you look and feel younger.', 'Someone is speaking well of you.', 'The time is right to make new friends.', 'You will inherit some money or a small piece of land.', 'Your life will be happy and peaceful.', 'A friend is a present you give yourself.', 'A member of your family will soon do something that will make you proud.', 'A quiet evening with friends is the best tonic for a long day.', 'A single kind word will keep one warm for years.', 'Anger begins with folly, and ends with regret.', 'Generosity and perfection are your everlasting goals.', 'Happy news is on its way to you.', 'He who laughs at himself never runs out of things to laugh at.', 'If your desires are not extravagant they will be granted.', 'Let there be magic in your smile and firmness in your handshake.', 'If you want the rainbow, you must to put up with the rain. D. Parton', 'Nature, time and patience are the three best physicians.', 'Strong and bitter words indicate a weak cause.', 'The beginning of wisdom is to desire it.', 'You will have a very pleasant experience.', 'You will inherit some money or a small piece of land.', 'You will live a long, happy life.', 'You will spend old age in comfort and material wealth.', 'You will step on the soil of many countries.', 'You will take a chance in something in the near future.', 'You will witness a special ceremony.', 'Your everlasting patience will be rewarded sooner or later.', 'Your great attention to detail is both a blessing and a curse.', 'Your heart is a place to draw true happiness.', 'Your ability to juggle many tasks will take you far.', 'A friend asks only for your time, not your money.', 'You will be invited to an exciting event.'];
    return $scope.showToast(fortunes[Math.floor(Math.random() * fortunes.length)]);
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
      if ($localStorage.selected != null) {
        $scope.user = $localStorage.selected;
      }
    });
  };
  refresh();
};

angular.module('app').controller('MainController', ['$scope', 'userService', '$mdSidenav', '$mdBottomSheet', '$log', '$q', '$mdDialog', '$localStorage', '$location', '$mdToast', MainController]);
