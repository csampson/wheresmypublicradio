'use strict';

var del = require('del');

var source = require('vinyl-source-stream'),
    buffer = require('vinyl-buffer');

var gulp       = require('gulp'),
    gulpUtil   = require('gulp-util'),
    uglify     = require('gulp-uglify'),
    sourcemaps = require('gulp-sourcemaps');
    
var browserify = require('browserify'),
    watchify   = require('watchify');

var stylus = require('gulp-stylus'),
    nib    = require('nib');

var config = {
  debug: gulpUtil.env.type !== 'production'
};

var scriptBundler = browserify({
  entries: './assets/js/app.js',
  debug: config.debug
});

function bundleScripts(options) {
  var bundler = options.watch ? watchify(scriptBundler) : scriptBundler,
      stream  = bundler.bundle();

  if (options.watch) {
    bundler.on('update', function() {
      console.log('Re-bundling scripts...'); // TODO: built-in way to handle this logging..?
      bundleScripts({ watch: false });
    });
  }

  if (config.debug) {
    stream.on('error', gulpUtil.log.bind(gulpUtil, 'Browserify Error'));
  }

  return stream
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(uglify())
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('./public/js'));
}

gulp.task('clean-css', function() {
  return del('./static/**/*.css');
});

gulp.task('bundle-css', ['clean-css'], function () {
  return gulp.src('./assets/css/app.styl')
    .pipe(stylus({ use: [nib()] }))
    .pipe(gulp.dest('./public/css/'));
});

gulp.task('watch-css', ['bundle-css'], function() {
  gulp.watch('./assets/**/*.styl', ['bundle-css']);
});

gulp.task('clean-js', function() {
  return del('./static/**/*.js');
});

gulp.task('bundle-js', ['clean-js'], function() {
  bundleScripts({ watch: false });
});

gulp.task('watch-js', ['bundle-js'], function() {
  bundleScripts({ watch: true });
});

gulp.task('bundle', ['bundle-css', 'bundle-js']);
gulp.task('watch', ['watch-css', 'watch-js']);
