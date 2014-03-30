describe('app controllers', function() {
  beforeEach(module('app'));

  describe('StationFinderCtrl', function() {
    var StationFinderCtrl, injector, scope, $rootScope, $controller, $q, $httpBackend, geolocation;

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

      scope.geolocation = { latitude: 90, longitude: 90 };
      scope.findStation();
      $httpBackend.flush();

      expect(scope.bestStation).toEqual({label: '89.9 FM - WWNO'});
    });
  });
});
