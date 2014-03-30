describe('app services', function() {
  beforeEach(module('app.services'));

  describe('stationFinder', function() {
    var stationFinder, injector, $httpBackend;

    beforeEach(inject(function($injector) {
      injector      = $injector;
      stationFinder = injector.get('stationFinder');
      $httpBackend  = injector.get('$httpBackend');
    }));


    describe('loading state', function() {
      it('should reflect as loading while searching', function() {
        var geolocation = {};

        stationFinder.findBestStation(geolocation);

        expect(stationFinder.loading).toBe(true);
      });

      it('should reflect as NOT loading when a best station response is returned', function() {
        $httpBackend.whenGET(/^\/best_station*/).respond({});
        var geolocation = {};

        stationFinder.findBestStation(geolocation).then(function(result) {
          expect(stationFinder.loading).toBe(false);
        });

        $httpBackend.flush();
      });

      it('should reflect as NOT loading when an error is returned', function() {
        $httpBackend.whenGET(/^\/best_station*/).respond(undefined);
        var geolocation = {};

        stationFinder.findBestStation(geolocation).then(function(result) {
          expect(stationFinder.loading).toBe(false);
        });

        $httpBackend.flush();
      });
    });
  });
});