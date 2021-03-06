angular.module('app.services', [])
  .service('geolocation', ['$q', function($q) {
    this.getPosition = function() {
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
    };
  }])
  .service('geocoder', ['$q', function($q) {
    var geocoder = new google.maps.Geocoder();

    this.geocode = function(location) {
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
    };
  }])
  .factory('stationFinder', ['$q', '$http', function($q, $http) {
    var stationFinder = {
      bestStation: null,
      loading: false,
      toggleLoading: function(enable) {
        this.loading = enable;
        return this;
      },
      findBestStation: function(geolocation) {
        var deferred = $q.defer();

        stationFinder.toggleLoading(true);

        $http.get('/best_station', {params: geolocation}).success(function(response) {
          stationFinder.toggleLoading(false);

          if(!response) {
            deferred.resolve({ error: "We couldn't find any member stations in your area." });
          }
          else {
            stationFinder.bestStation = response;
            deferred.resolve();
          }
        });

        return deferred.promise;
      }
    };

    return stationFinder;
  }]);
