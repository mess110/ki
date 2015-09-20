var BlobController;

BlobController = function($scope, $routeParams, $location, $localStorage, $mdBottomSheet) {
  if (($routeParams.id == null) && ($localStorage.selected != null)) {
    $location.path("/blobs/" + $localStorage.selected.api_key);
    return;
  }
  if ($routeParams.id != null) {
    $scope.user = $localStorage.selected;
    jNorthPole.getStorage($scope.user, function(data) {
      $scope.items = data;
      return $scope.$apply();
    }, function(error) {
      return console.log(error);
    });
  } else {
    console.log('nothing to see here');
  }
  $scope["delete"] = function(item) {
    item = angular.copy(item);
    item.secret = $scope.user.secret;
    jNorthPole.deleteStorage(item, function(data) {
      var i, len, r, ref;
      ref = $scope.items;
      for (i = 0, len = ref.length; i < len; i++) {
        r = ref[i];
        if (r.id === item.id) {
          $scope.items.splice($scope.items.indexOf(r), 1);
          break;
        }
      }
      return $scope.$apply();
    }, function(error) {
      return console.log(error);
    });
  };
  $scope.save = function(item) {
    var callback;
    item = angular.copy(item);
    item.api_key = $scope.user.api_key;
    item.secret = $scope.user.secret;
    callback = function(data) {
      return console.log(data);
    };
    if (item.id != null) {
      return jNorthPole.putStorage(item, callback);
    } else {
      return jNorthPole.createStorage(item, function(data) {
        $scope.items.push(data);
        return $scope.$apply();
      }, callback);
    }
  };
  $scope.newPanel = function() {
    return $scope.save({
      text: ''
    });
  };
  $scope.showContactOptions = function($event, json) {
    var ContactPanelController;
    json = angular.copy(json);
    ContactPanelController = function($mdBottomSheet, $scope) {
      this.json = json;
      this.actions = [
        {
          name: 'Delete',
          icon: 'delete'
        }
      ];
      this.submitContact = function(action) {
        $mdBottomSheet.hide(action);
      };
    };
    return $mdBottomSheet.show({
      parent: angular.element(document.getElementById('content')),
      templateUrl: './js/users/contactSheet.html',
      controller: ['$mdBottomSheet', '$scope', ContactPanelController],
      controllerAs: 'cp',
      bindToController: true,
      targetEvent: $event
    }).then(function(clickedItem) {
      if (clickedItem.name === 'Delete') {
        $scope["delete"](json);
      }
    });
  };
};

angular.module('users').controller('BlobController', ['$scope', '$routeParams', '$location', '$localStorage', '$mdBottomSheet', BlobController]);
