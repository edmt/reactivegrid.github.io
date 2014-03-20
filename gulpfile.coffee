'use strict'

gulp  = require('gulp')
$     = require('gulp-load-plugins')()
spawn = require('child_process').spawn;

#########

paths =
  js: ['_scripts/jquery.js', '_scripts/bootstrap.js']
  coffee: ['_scripts/**/*.coffee']
  jekyll: ['css/', 'js/', '_layouts/', '_includes/', 'archive/', 'team/', 'index.html', '_site/']

# Clean
gulp.task 'clean', ->
  gulp
    .src(paths.jekyll, read: false )
    .pipe($.clean())

# Styles
gulp.task 'styles', ->
  gulp
    .src('_scss/main.scss')
    .pipe($.changed('css/'))
    .pipe($.plumber())
    .pipe($.rubySass( style: 'compressed' ))
    .pipe(gulp.dest('css/'))

# Coffee
gulp.task 'coffee', ->
  gulp
    .src(paths.coffee)
    .pipe($.changed('js/', extension: '.coffee'))
    .pipe($.plumber())
    .pipe($.coffee({ bare: true }))
    .pipe($.concat('main.js'))
    .pipe(gulp.dest('js/'))

# Scripts
gulp.task 'scripts', ->
  gulp
    .src(paths.js)
    .pipe($.changed('js/', extension: '.js'))
    .pipe($.plumber())
    .pipe($.concat('vendor.js'))
    .pipe($.uglify())
    .pipe(gulp.dest('js/'))

# Templates
gulp.task 'templates', ->
  gulp
    .src('_templates/**/*.jade')
    .pipe($.changed('./', extension: '.html'))
    .pipe($.plumber())
    .pipe($.jade({ pretty: true }))
    .pipe(gulp.dest('./'))

# Jekyll
gulp.task 'jekyll', ->
  spawn('jekyll', ['serve', '-w'], stdio: 'inherit')

# Build
gulp.task 'build', ['clean', 'templates', 'styles', 'scripts', 'coffee'], ->
  gulp.start('jekyll')

# Watch
gulp.task 'watch', ['build'], ->
  gulp.watch('_scss/**/*.scss', ['styles'])
  gulp.watch('_scripts/**/*.coffee', ['coffee'])
  gulp.watch('_scripts/**/*.js', ['scripts'])
  gulp.watch('_templates/**/*.jade', ['templates'])

# Default
gulp.task 'default', ->
  gulp.start('watch')
