'use strict';

/**
 * @ngdoc directive
 * @name northpole.pullToRefresh.directive:pullToRefresh
 * @description
 * # pullToRefresh
 * # Copied from https://github.com/infomofo/angular-md-pull-to-refresh, plan on modifiying
 */
angular.module('northpole.pullToRefresh', []).directive('pullToRefresh', function($timeout) {
  return {
    restrict: 'A',
    transclude: true,
    template: '<md-progress-linear md-mode="indeterminate" class="md-accent ng-hide im-pull-to-refresh-progress-bar" ng-show="pullToRefreshActive"></md-progress-linear><ng-transclude></ng-transclude>',
    scope: {
      refreshFunction: '&'
    },
    link: function(scope, element, attrs) {
      scope.hasCallback = angular.isDefined(attrs.refreshFunction);
      scope.isAtTop = false;
      scope.pullToRefreshActive = false;
      scope.lastScrollTop = 0;
      scope.pullToRefresh = function() {
        if (scope.hasCallback) {
          if (!scope.pullToRefreshActive) {
            scope.pullToRefreshActive = true;
            scope.refreshFunction().then(function() {
              scope.pullToRefreshActive = false;
            });
            scope.$digest();
          }
        }
      };
      $timeout((function() {
        var onScroll;
        onScroll = function(event) {
          if (element[0].scrollTop <= 0 && scope.lastScrollTop <= 0) {
            if (scope.isAtTop) {
              scope.pullToRefresh();
            } else {
              scope.isAtTop = true;
            }
          }
          scope.lastScrollTop = element[0].scrollTop;
        };
        element[0].addEventListener('scroll', onScroll);
        element[0].addEventListener('touchmove', onScroll);
      }), 1000);
    }
  };
});
