clApp = angular.module("clApp", [])

clApp.controller "ShopController", ($scope, $http) ->
  $scope.shopping_items = []
  $scope.item = {
    name: ""
    qty: 1
  }

  $scope.refresh = ->
    $http.get("/items.json").success((data, status, headers, config) ->
      $scope.shopping_items = data
    ).error (data, status, headers, config) ->
      console.log data
  $scope.refresh()

  $scope.update= (item) ->
    $http.put("/items.json", item
    ).success((data, status, headers, config) ->
      $scope.refresh()
    ).error (data, status, headers, config) ->
      console.log data

  $scope.create= ->
    if $scope.item.name? and $scope.item.qty? and $scope.item.name != ''
      $http.post("/items.json", {
        name: $scope.item.name
        qty: $scope.item.qty
      }).success((data, status, headers, config) ->
        $scope.item = {
          name: ""
          qty: 1
        }
        $scope.refresh()
      ).error (data, status, headers, config) ->
        console.log data

  $scope.delete= (id) ->
    $http.delete("/items.json?id=#{id}",
    ).success((data, status, headers, config) ->
      $scope.refresh()
    ).error (data, status, headers, config) ->
      console.log data
