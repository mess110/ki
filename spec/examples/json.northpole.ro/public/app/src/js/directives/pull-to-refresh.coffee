'use strict'

###*
# @ngdoc directive
# @name northpole.pullToRefresh.directive:pullToRefresh
# @description
# # pullToRefresh
# # Copied from https://github.com/infomofo/angular-md-pull-to-refresh, plan on modifiying
###

angular.module('northpole.pullToRefresh', []).directive 'pullToRefresh', ($timeout) ->
  {
    restrict: 'A'
    transclude: true
    template: '<md-progress-linear md-mode="indeterminate" class="md-accent ng-hide im-pull-to-refresh-progress-bar" ng-show="pullToRefreshActive"></md-progress-linear><ng-transclude></ng-transclude>'
    scope: refreshFunction: '&'
    link: (scope, element, attrs) ->
      scope.hasCallback = angular.isDefined(attrs.refreshFunction)
      scope.isAtTop = false
      scope.pullToRefreshActive = false
      scope.lastScrollTop = 0

      scope.pullToRefresh = ->
        if scope.hasCallback
          if !scope.pullToRefreshActive
            scope.pullToRefreshActive = true
            scope.refreshFunction().then ->
              scope.pullToRefreshActive = false
              return
            scope.$digest()
        return

      # Wait 1 second and then add an event listener to the scroll events on this list- this enables pull to refresh functionality
      $timeout (->

        onScroll = (event) ->
          if element[0].scrollTop <= 0 and scope.lastScrollTop <= 0
            #uncomment this line for desktop testing
            #if (element[0].scrollTop <= 0) {
            if scope.isAtTop
              scope.pullToRefresh()
            else
              scope.isAtTop = true
          scope.lastScrollTop = element[0].scrollTop
          return

        element[0].addEventListener 'scroll', onScroll
        element[0].addEventListener 'touchmove', onScroll
        return
      ), 1000
      return

  }
