angular.module('wheresMyNpr.directives', [])
  .directive('radioStreamer', ['$http', '$sce', function($http, $sce) {
    return {
      template: "\
        <i class='{{actionIcon}}'></i>\
        Listen \
        <audio data-ng-src='{{source}}'></audio>\
      ",
      link: function(scope, element, attributes) {
        scope.actionIcon = 'fa-play fa';

        scope.play = function() {
          scope.playing = true;
          scope.actionIcon = 'fa-pause fa';
          element.find('audio')[0].play();
        };

        scope.pause = function() {
          scope.playing = false;
          scope.actionIcon = 'fa-play fa';
          element.find('audio')[0].pause();
        };

        scope.$watch('source', function(source) {
          if(source) scope.play();
        });

        // handle resetting when changing stations
        scope.$parent.$watch('bestStation', function() {
          delete scope.source;
          scope.pause();
        });

        element.on('click', function() {
          if(!scope.source) {
            $http.get('/listen', { params: { url: attributes.streamUrl }}).success(function(response) {
              // TODO: handle errors
              scope.source = $sce.trustAsResourceUrl(response);
            });
          }
          else {
            if(scope.playing)
              scope.pause();
            else
              scope.play();
          }

          scope.$apply();
        });
      }
    };
  }]);
