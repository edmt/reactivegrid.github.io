'use strict'

gulp = require('gulp')
$    = require('gulp-load-plugins')()

#########

# Clean
# Removes .tmp folder
gulp.task 'clean', ->
  gulp
    .src(['.tmp/', '_site/'], {read: false})
    .pipe($.clean())

# Styles
# 1. Compiles all Sass (scss) files under the _scss folder
# 2. Minifies main.css file whit clean-css
gulp.task 'styles', ->
  gulp
    .src('_scss/main.scss')
    .pipe($.plumber())
    .pipe($.rubySass( style: 'compressed' ))
    .pipe(gulp.dest('css/'))

# Coffee
# Compiles all the CoffeeScript files under the _scripts folder
gulp.task 'coffee', ->
  gulp
    .src('_scripts/**/*.coffee')
    .pipe($.plumber())
    .pipe($.coffee({ bare: true }))
    .pipe(gulp.dest('.tmp/'))

# Scripts
# 1. Concatenates JS files under .tmp and _scripts folders in to main.js file
# 2. Minifies main.js with uglify.js
gulp.task 'scripts', ['coffee'], ->
  gulp
    .src(['_scripts/**/*.js', '.tmp/**/*.js'])
    .pipe($.plumber())
    .pipe($.concat('main.js'))
    .pipe($.uglify())
    .pipe(gulp.dest('js/'))

# Templates
# Compiles all the Jade templates under the _templates folder
gulp.task 'templates', ->
  gulp
    .src('_templates/**/*.jade')
    .pipe($.plumber())
    .pipe($.jade({ pretty: true }))
    .pipe(gulp.dest('./'))

# Build
# 1. Cleans .tmp and _site folders
# 2. Compiles Jade, CoffeeScript and Sass
gulp.task 'build', ['clean'], ->
  gulp.start(['templates', 'styles', 'scripts'])
  gulp.src('./').pipe($.exec('jekyll build'))

# Watch
# Watches for changes in the styles, scripts and markup
gulp.task 'watch', ['build'], ->
  gulp.watch('_scss/**/*.scss', ['styles'])
  gulp.watch('_scripts/**/*.coffee', ['coffee'])
  gulp.watch('_scripts/**/*.js', ['scripts'])
  gulp.watch('_templates/**/*.jade', ['templates'])

# Default
gulp.task 'default', ->
  gulp.start('watch')
