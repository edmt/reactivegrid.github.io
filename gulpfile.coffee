'use strict'

gulp = require('gulp')
$    = require('gulp-load-plugins')()

#########

paths =
  js: ['_scripts/jquery.js', '_scripts/bootstrap.js']
  coffee: ['_scripts/**/*.coffee']
  jekyll: ['css', 'js', '_layouts', '_includes', 'archive', 'index.html']

# Clean
gulp.task 'clean', ->
  gulp
    .src(paths.jekyll, read: false )
    .pipe($.clean())

# Styles
gulp.task 'styles', ->
  gulp
    .src('_scss/main.scss')
    .pipe($.plumber())
    .pipe($.rubySass( style: 'compressed' ))
    .pipe(gulp.dest('css/'))

# Coffee
gulp.task 'coffee', ->
  gulp
    .src(paths.coffee)
    .pipe($.plumber())
    .pipe($.coffee({ bare: true }))
    .pipe($.concat('main.js'))
    .pipe(gulp.dest('js/'))

# Scripts
gulp.task 'scripts', ->
  gulp
    .src(paths.js)
    .pipe($.plumber())
    .pipe($.concat('vendor.js'))
    .pipe($.uglify())
    .pipe(gulp.dest('js/'))

# Templates
gulp.task 'templates', ->
  gulp
    .src('_templates/**/*.jade')
    .pipe($.plumber())
    .pipe($.jade({ pretty: true }))
    .pipe(gulp.dest('./'))

# Build
gulp.task 'build', ['clean', 'templates', 'styles', 'scripts', 'coffee']

# Watch
gulp.task 'watch', ['build'], ->
  gulp.watch('_scss/**/*.scss', ['styles'])
  gulp.watch('_scripts/**/*.coffee', ['coffee'])
  gulp.watch('_scripts/**/*.js', ['scripts'])
  gulp.watch('_templates/**/*.jade', ['templates'])

# Default
gulp.task 'default', ->
  gulp.start('watch')
