angular.module('wheresMyNpr.controllers', [])
  .controller('StationFinderCtrl', ['$scope', '$http', 'geolocation', function($scope, $http, geolocation) {
    $scope.findByZip = function() {
      $http.get('/best_station', { params: { zipcode: $scope.zipcode }}).success(function(response) {
        $scope.bestStation = response;
      });
    };

    $scope.findByLocation = function() {
      geolocation.getPosition().then(function(result) {
        $http.get('/best_station', { params: result}).success(function(response) {
          $scope.bestStation = response;
        });
      });
    };
  }]);
