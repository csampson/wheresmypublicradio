angular.module('app.controllers', [])
  .controller('StationFinderCtrl', ['$scope', '$http', 'geolocation', function($scope, $http, geolocation) {
    $scope.toggleLoading = function() {
      $scope.loading = !$scope.loading;
    };

    $scope.clearData = function() {
      $scope.bestStation = $scope.errorMessage  = null;
    };

    $scope.getGeolocation = function() {
      geolocation.getPosition().then(function(result) {
        if ('error' in result) {
          $scope.toggleLoading();
          $scope.errorMessage = 'There was a problem determining your current geolocation.';

          return;
        }

        $scope.geolocation = result;
      });
    };

    $scope.findStation = function() {
      $scope.clearData();
      $scope.toggleLoading();
      $scope.findBestStation($scope.geolocation);
    };

    // TODO: station finder service
    $scope.findBestStation = function(geolocation) {
      $http.get('/best_station', {params: geolocation}).success(function(response) {
        if(!response) {
          $scope.errorMessage = "We couldn't find any member stations in your area.";
        }
        else {
          $scope.bestStation = response;
        }

        $scope.toggleLoading();
      });
    };
  }]);
