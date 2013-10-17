var wheresMyNpr = angular.module('wheresMyNpr', []);

wheresMyNpr.controller('StationFinderCtrl', function($scope, $http, $q) {
  $scope.getLocation = function() {
    var deferred = $q.defer();

    navigator.geolocation.getCurrentPosition(
      function(geoposition) {
        $scope.$apply(function() {
          deferred.resolve({ latitude: geoposition.coords.latitude, longitude: geoposition.coords.longitude });
        });
      },
      function(error) {
        deferred.resolve({ error: error });
      }
    );

    return deferred.promise;
  };

  $scope.findByZip = function() {
    $http.get('/best_station', { params: { zipcode: $scope.zipcode }}).success(function(response) {
      $scope.bestStation = response;
    });
  };

  $scope.findByLocation = function() {
    $scope.getLocation().then(function(result) {
      // TODO: handle errors

      $http.get('/best_station', { params: result}).success(function(response) {
        $scope.bestStation = response;
      });
    });
  };
});
