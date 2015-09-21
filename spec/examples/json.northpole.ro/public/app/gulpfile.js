var gulp = require('gulp');
var gutil = require('gulp-util');
var order = require('gulp-order');
var concat = require('gulp-concat');
var del = require('del');
var coffee = require('gulp-coffee');
var sass = require('gulp-sass');
var processhtml = require('gulp-processhtml');

var paths = {
  coffee: ['src/**/*.coffee'],
  sass: ['src/**/*.sass'],
  html: ['src/**/*.html'],
  icons: ['src/**/*.svg'],
  vendor: {
    icons: [
      './bower_components/material-design-icons/communication/svg/production/contact_mail_48px.svg',
      { group: 'social', icon: 'ic_person_add_48px.svg' },
      { group: 'notification', icon: 'ic_adb_48px.svg' },
      { group: 'content', icon: 'ic_clear_48px.svg' },
      { group: 'content', icon: 'ic_add_48px.svg' },
      { group: 'action', icon: 'ic_settings_48px.svg' },
      { group: 'action', icon: 'ic_delete_48px.svg' }
    ],
    js: [
      './bower_components/angular/angular.js',
      './bower_components/angular-route/angular-route.js',
      './bower_components/angular-animate/angular-animate.js',
      './bower_components/angular-aria/angular-aria.js',
      './bower_components/ngstorage/ngStorage.js',
      './bower_components/angular-material/angular-material.js'
    ],
    css: [
      './bower_components/angular-material/angular-material.css'
    ]
  },
  output: './build/',
  outputSvg: 'assets/svg/'
};

paths.vendor.icons = paths.vendor.icons.map(function (obj) {
  if (typeof(obj) === 'string') {
    return obj;
  } else {
    return './bower_components/material-design-icons/' + obj.group + '/svg/production/' + obj.icon;
  }
});

gulp.task('coffee', function () {
  gulp.src(paths.coffee)
    .pipe(coffee({bare: true})
    .on('error', gutil.log))
    .pipe(gulp.dest(paths.output));
});

gulp.task('vendor', function () {
  gulp.src(paths.vendor.js)
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest(paths.output + 'js'));

  gulp.src(paths.vendor.css)
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest(paths.output + 'css'));

  gulp.src(paths.vendor.icons)
    .pipe(gulp.dest(paths.output + paths.outputSvg))

  gulp.src(paths.icons)
    .pipe(gulp.dest(paths.output))
});

gulp.task('sass', function () {
  gulp.src(paths.sass)
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest(paths.output));
});

gulp.task('clean', function () {
  return del([
    'build/**/*.js',
    'build/**/*.css',
    'build/**/*.html',
    'build/**/*.svg'
  ]);
});

gulp.task('html', function () {
  return gulp.src(paths.html)
    .pipe(processhtml({}))
    .pipe(gulp.dest(paths.output));
});

gulp.task('watch', function() {
  gulp.watch(paths.coffee, ['coffee']);
  gulp.watch(paths.sass, ['sass']);
  gulp.watch(paths.html, ['html']);
});

gulp.task('dev', ['clean', 'vendor', 'sass', 'coffee', 'html', 'watch']);
gulp.task('prod', ['clean', 'vendor', 'sass', 'coffee', 'html']);

gulp.task('default', ['dev']);
