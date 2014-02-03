describe('app controllers', function() {
  beforeEach(module('app'));

  describe('StationFinderCtrl', function() {
    var StationFinderCtrl, injector, scope, $rootScope, $controller, $q, $httpBackend, geolocation;

    // fake geolocation
    function getFakeLocation() {
      var defered = $q.defer();
      defered.resolve({ latitude: 90, longitude: 90 });
      return defered.promise;
    }

    beforeEach(inject(function($injector) {
      injector     = $injector;
      scope        = injector.get('$rootScope');
      $controller  = injector.get('$controller');
      $q           = injector.get('$q');
      $httpBackend = injector.get('$httpBackend');
      geolocation  = injector.get('geolocation');

      $controller('StationFinderCtrl', { $scope : scope });
    }));

    it('should be able to fetch and store the best station', function() {
      $httpBackend.whenGET(/^\/best_station*/).respond({ label: '89.9 FM - WWNO' });

      spyOn(geolocation, 'getPosition').andCallFake(getFakeLocation);
      scope.findByLocation();
      $httpBackend.flush();

      expect(scope.bestStation).toEqual({label: '89.9 FM - WWNO'});
    });

    it('should set an error message if the best station cannot be found', function() {
      $httpBackend.whenGET(/^\/best_station*/).respond(undefined);

      spyOn(geolocation, 'getPosition').andCallFake(getFakeLocation);
      scope.findByLocation();
      $httpBackend.flush();

      expect(scope.errorMessage).toBe("We couldn't find any member stations in your area.");
    });

    describe('loading state', function() {
      it('should reflect as loading when searching for stations by zipcode', function() {
        scope.zipcode = 70130;
        scope.findByZip();

        expect(scope.loading).toBe(true);
      });

      it('should reflect as loading when searching for stations by geolocation', function() {
        spyOn(geolocation, 'getPosition').andCallFake(getFakeLocation);
        scope.findByLocation();

        expect(scope.loading).toBe(true);
      });

      it('should reflect as NOT loading when a best station response is returned', function() {
        $httpBackend.whenGET(/^\/best_station*/).respond({});

        scope.zipcode = 70130;
        scope.findByZip();
        $httpBackend.flush();

        expect(scope.loading).toBe(false);
      });

      it('should reflect as NOT loading when an error is returned', function() {
        $httpBackend.whenGET(/^\/best_station*/).respond({});

        scope.zipcode = 'wamp';
        scope.findByZip();
        $httpBackend.flush();

        expect(scope.loading).toBe(false);
      });
    });
  });
});
