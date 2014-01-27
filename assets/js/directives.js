angular.module('wheresMyNpr.directives', [])
  .directive('radioStreamer', ['$http', function($http) {
    return {
      template: "<i class='{{actionIcon}}'></i> Listen <span class='radio-streamer-jplayer'></span>",
      link: function(scope, element, attributes) {
        scope.actionIcon = 'fa-play fa';

        scope.play = function() {
          scope.playing = true;
          scope.actionIcon = 'fa-pause fa';
          element.find('.radio-streamer-jplayer').jPlayer('play');
        };

        scope.pause = function() {
          scope.playing = false;
          scope.actionIcon = 'fa-play fa';
          element.find('.radio-streamer-jplayer').jPlayer('pause');
        };

        scope.$watch('source', function(source) {
          if(source) scope.play();
        });

        element.find('.radio-streamer-jplayer').jPlayer({
          swfPath: '/',
          supplied: 'mp3',
          solution: 'flash, html', // prefer flash, ironically - there's an issue with streaming these mp3 endpoints in non-webkit browsers
          wmode: 'window'
        });

        element.on('click', function() {
          if(!scope.source) {
            $http.get('/listen', { params: { url: attributes.streamUrl }}).success(function(response) {
              scope.source = response;
              element.find('.radio-streamer-jplayer').jPlayer('setMedia', { mp3: scope.source });
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
  }])
  .directive('placeheldField', function() {
    return {
      link: function(scope, element, attributes) {
        var input = element.find('input'); // TODO: refactor this to leverage directive API
        input.attr('data-placeheld', !input.val());
        input.on('change', function() { input.attr('data-placeheld', !input.val()); });
      }
    }
  });
