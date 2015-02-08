'use strict';

var source = require('vinyl-source-stream');

var gulp     = require('gulp'),
    gulpUtil = require('gulp-util');
    
var browserify = require('browserify'),
    watchify   = require('watchify');

var config = {
  browserify: {
    debug: gulpUtil.env.type !== 'production'
  }
};

var bundler = watchify(browserify('./assets/js/app.js', config.browserify));

function bundle() {
  return bundler.bundle()
    .on('error', gulpUtil.log.bind(gulpUtil, 'Browserify Error'))
    .pipe(source('app.js'))
    .pipe(gulp.dest('./public/js'));
}

gulp.task('build', bundle);

bundler.on('update', function() {
  gulpUtil.log('Re-bundling...');
  bundle();
});
