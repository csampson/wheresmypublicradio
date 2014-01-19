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
            // TODO error messages
            deferred.resolve({ error: error });
          }
        );

        return deferred.promise;
      }
    };
  }]);