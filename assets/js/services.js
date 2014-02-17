angular.module('app.services', [])
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
  }])
  .factory('geocoder', ['$q', function($q) {
    var geocoder = new google.maps.Geocoder();

    return {
      geocode: function(location) {
        var deferred = $q.defer();

        geocoder.geocode({ 'address': location }, function(results, status) {
          if (status === google.maps.GeocoderStatus.OK) {
            var geolocation = results[0].geometry.location;
            deferred.resolve({ longitude: geolocation.lng(), latitude: geolocation.lat() });
          }
          else {
            deferred.resolve({ error: status });
          }
        });

        return deferred.promise;
      }
    };
  }]);
