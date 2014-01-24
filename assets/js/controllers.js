angular.module('wheresMyNpr.controllers', [])
  .controller('StationFinderCtrl', ['$scope', '$http', 'geolocation', function($scope, $http, geolocation) {
    $scope.toggleLoading = function() {
      $scope.loading = !$scope.loading;
      $scope.loaded = !$scope.loading;
    };

    $scope.findByZip = function() {
      $scope.toggleLoading();

      $http.get('/best_station', { params: { zipcode: $scope.zipcode }}).success(function(response) {
        $scope.bestStation = response;
        $scope.toggleLoading();
      });
    };

    $scope.findByLocation = function() {
      $scope.toggleLoading();

      geolocation.getPosition().then(function(result) {
        if ('error' in result) {
          $scope.toggleLoading();
          $scope.errorMessage = 'There was a problem determing your current geolocation.';

          return;
        }

        $http.get('/best_station', { params: result}).success(function(response) {
          $scope.bestStation = response;
          $scope.toggleLoading();
        });
      });
    };
  }]);
