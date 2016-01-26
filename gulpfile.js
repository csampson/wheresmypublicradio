'use strict';

const del    = require('del');
const source = require('vinyl-source-stream');
const buffer = require('vinyl-buffer');

const gulp       = require('gulp');
const gulpUtil   = require('gulp-util');
const uglify     = require('gulp-uglify');
const sourcemaps = require('gulp-sourcemaps');

let config = {
  debug: gulpUtil.env.type !== 'production'
};

let scriptBundler = browserify({
  entries: './assets/js/app.js',
  debug: config.debug
});
