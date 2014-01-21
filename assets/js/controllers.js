angular.module('wheresMyNpr.controllers', [])
  .controller('StationFinderCtrl', ['$scope', '$http', 'geolocation', function($scope, $http, geolocation) {
    $scope.findByZip = function() {
      $scope.loading = true;

      $http.get('/best_station', { params: { zipcode: $scope.zipcode }}).success(function(response) {
        $scope.bestStation = response;
        $scope.loading = false;
      });
    };

    $scope.findByLocation = function() {
      $scope.loading = true;

      geolocation.getPosition().then(function(result) {
        $http.get('/best_station', { params: result}).success(function(response) {
          $scope.bestStation = response;
          $scope.loading = false;
        });
      });
    };
  }]);
