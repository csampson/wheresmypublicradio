angular.module('wheresMyNpr.services', [])
  .factory('geolocation', ['$q', function($q) {
    return {
      getPosition: function() {
        var deferred = $q.defer();

        navigator.geolocation.getCurrentPosition(
          function(geoposition) {
            deferred.resolve({ latitude: geoposition.coords.latitude, longitude: geoposition.coords.longitude });
          },
          function(error) {
            deferred.resolve({ error: error });
          },
          {
            timeout: 15000
          }
        );

        return deferred.promise;
      }
    };
  }]);