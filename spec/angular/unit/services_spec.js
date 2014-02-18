describe('app services', function() {
  beforeEach(module('app.services'));

  describe('stationFinder', function() {
    var stationFinder, injector, $httpBackend;

    beforeEach(inject(function($injector) {
      injector      = $injector;
      stationFinder = injector.get('stationFinder');
      $httpBackend  = injector.get('$httpBackend');
    }));

    it('should be able to fetch the best station', function() {
      $httpBackend.whenGET(/^\/best_station*/).respond({ label: '89.9 FM - WWNO' });

      var geolocation = { latitude: 90, longitude: 90 },
          fetch       = stationFinder.findBestStation(geolocation);

      $httpBackend.flush();

      fetch.then(function(result) {
        expect(result).toEqual({ latitude: 90, longitude: 90 });
      });
    });

    it('should handle fetch errors', function() {
      $httpBackend.whenGET(/^\/best_station*/).respond('');

      var geolocation = { latitude: 90, longitude: 90 },
          fetch       = stationFinder.findBestStation(geolocation);

      $httpBackend.flush();

      fetch.then(function(result) {
        expect(result.error).toBeDefined();
      });
    });
  });
});