angular.module('app.controllers', [])
  .controller('StationFinderCtrl', ['$scope', '$http', 'geolocation', 'geocoder', 'stationFinder', function($scope, $http, geolocation, geocoder, stationFinder) {
    $scope.toggleLoading = function() {
      $scope.loading = !$scope.loading;
    };

    $scope.clearData = function() {
      $scope.bestStation = $scope.errorMessage =  null;
    };

    $scope.getGeolocation = function() {
      geolocation.getPosition().then(function(result) {
        if ('error' in result) {
          $scope.toggleLoading();
          $scope.errorMessage = 'There was a problem determining your current geolocation.';

          return;
        }

        $scope.geolocation = result;
        $scope.location = 'My location';
      });
    };

    $scope.findStation = function() {
      $scope.clearData();
      $scope.loading = true;

      if($scope.geolocation) {
        stationFinder.findBestStation($scope.geolocation).then(function(result) {
          $scope.toggleLoading();

          if('error' in result) {
            $scope.errorMessage = "We couldn't find any member stations in your area.";
          }
          else {
            $scope.bestStation = result;
          }
        });

        return;
      }

      // if there's no stored geolocation, attempt to resolve one based on what user entered in the $scope.location field
      geocoder.geocode($scope.location).then(function(result) {
        if('error' in result) {
          $scope.toggleLoading();
          $scope.errorMessage = "We couldn't find any member stations in your area.";
        }
        else {
          $scope.geolocation = result;
          $scope.findStation();
        }
      });
    };

    // clear out stored geolocation when location value changes
    $scope.$watch('location', function(value) {
      if(value !== 'My location') {
        $scope.geolocation = null;
      }
    });
  }]);
