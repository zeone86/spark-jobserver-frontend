'use strict';

var gulp = require('gulp'),
    changed = require('gulp-changed'),
    sass = require('gulp-sass'),
    csso = require('gulp-csso'),
    useref = require('gulp-useref'),
    autoprefixer = require('gulp-autoprefixer'),
    prefix = require('gulp-prefix'),
    browserify = require('browserify'),
    watchify = require('watchify'),
    source = require('vinyl-source-stream'),
    buffer = require('vinyl-buffer'),
    reactify = require('reactify'),
    coffeereactify = require('coffee-reactify'),
    uglify = require('gulp-uglify'),
    del = require('del'),
    notify = require('gulp-notify'),
    browserSync = require('browser-sync'),
    reload = browserSync.reload,
    p = {
      cjsx: './scripts/app.cjsx',
      sass: 'styles/main.sass',
      bundle: 'app.js',
      distJs: 'dist/js',
      distCss: 'dist/css'
    };

gulp.task('clean', function(cb) {
  del(['dist'], cb);
});

gulp.task('browserSync', function() {
  browserSync({
    server: {
      baseDir: ['./', 'dist/']
    }
  })
});

gulp.task('watchify', function() {
  var bundler = watchify(browserify(p.cjsx, watchify.args));

  function rebundle() {
    return bundler
      .bundle()
      .on('error', notify.onError())
      .pipe(source(p.bundle))
      .pipe(gulp.dest(p.distJs))
      .pipe(reload({stream: true}));
  }

  bundler.transform(coffeereactify)
  .on('update', rebundle);
  return rebundle();
});

gulp.task('build-jobserver', ['build'], function () {
  return gulp.src('dist/index.html')
    .pipe(prefix('html/', null, true))
    .pipe(gulp.dest('dist'));
});

gulp.task('build', ['styles', 'browserify'], function () {
  var assets = useref.assets();

  return gulp.src('index.html')
    .pipe(assets)
    .pipe(csso())
    .pipe(assets.restore())
    .pipe(useref())
    .pipe(gulp.dest('dist'));
});

gulp.task('browserify', ['clean'], function() {
  browserify(p.cjsx)
    .transform(coffeereactify)
    .bundle()
    .pipe(source(p.bundle))
    .pipe(buffer())
    .pipe(uglify())
    .pipe(gulp.dest(p.distJs));
});

function buildStyles() {
  return gulp.src(p.sass)
    .pipe(changed(p.distCss))
    .pipe(sass({errLogToConsole: true, sourceComments: 'normal'}))
    .on('error', notify.onError())
    .pipe(autoprefixer('last 1 version'))
    .pipe(csso())
    .pipe(gulp.dest(p.distCss))
    .pipe(reload({stream: true}));
}

gulp.task('watchStyles', buildStyles);

gulp.task('styles', ['clean'], buildStyles);

gulp.task('watchTask', function() {
  gulp.watch(p.scss, ['styles']);
});

gulp.task('watch', ['clean'], function() {
  gulp.start(['browserSync', 'watchTask', 'watchify', 'watchStyles']);
});

gulp.task('default', function() {
  console.log('Run "gulp watch, gulp build or build-jobserver"');
});
