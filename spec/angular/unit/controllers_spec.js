describe('app controllers', function() {
  beforeEach(module('app'));

  describe('StationFinderCtrl', function() {
    var StationFinderCtrl, $httpBackend, scope;

    beforeEach(inject(function(_$httpBackend_, $rootScope, $controller) {
      $httpBackend      = _$httpBackend_;
      scope             = $rootScope.$new();
      StationFinderCtrl = $controller('StationFinderCtrl', { $scope: scope });
    }));

    it('should be able to fetch and store the best station', function() {
      $httpBackend.whenGET(/^\/best_station*/).respond({ label: '89.9 FM - WWNO' });

      scope.geolocation = {};
      scope.findStation();
      $httpBackend.flush();

      expect(scope.stationFinder.bestStation).toEqual({ label: '89.9 FM - WWNO' });
    });
  });
});
