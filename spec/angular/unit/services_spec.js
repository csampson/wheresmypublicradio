describe('app services', function() {
  beforeEach(module('app.services'));

  describe('stationFinder', function() {
    var $httpBackend, stationFinder;

    beforeEach(inject(function(_$httpBackend_, _stationFinder_) {
      $httpBackend  = _$httpBackend_;
      stationFinder = _stationFinder_;
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

    describe('error messages', function() {
      it('should set an error message if the best station cannot be found', function() {
        $httpBackend.whenGET(/^\/best_station*/).respond(undefined);
        var geolocation = {};

        stationFinder.findBestStation(geolocation).then(function(result) {
          expect('error' in result).toBe(true);
          expect(result.error).toBe("We couldn't find any member stations in your area.");
        });

        $httpBackend.flush();
      });
    });
  });
});