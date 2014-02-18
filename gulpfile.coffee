'use strict'

gulp = require('gulp')
$    = require('gulp-load-plugins')()

#########

# Clean
# Removes .tmp folder
gulp.task 'clean', ->
  gulp
    .src(['.tmp/'], {read: false})
    .pipe($.clean())

# Styles
# 1. Compiles all Sass (scss) files under the _scss folder
# 2. Minifies main.css file whit clean-css
gulp.task 'styles', ->
  gulp
    .src('_scss/**/*.scss')
    .pipe($.sass())
    .pipe($.mincss())
    .pipe(gulp.dest('css/'))

# Coffee
# Compiles all the CoffeeScript files under the _scripts folder
gulp.task 'coffee', ->
  gulp
    .src('_scripts/**/*.coffee')
    .pipe($.coffee({ bare: true }))
    .pipe(gulp.dest('.tmp/'))

# Scripts
# 1. Concatenates JS files under .tmp and _scripts folders in to main.js file
# 2. Minifies main.js with uglify.js
gulp.task 'scripts', ['coffee'], ->
  gulp
    .src(['_scripts/**/*.js', '.tmp/**/*.js'])
    .pipe($.concat('main.js'))
    .pipe($.uglify())
    .pipe(gulp.dest('js/'))

# Templates
# Compiles all the Jade templates under the _templates folder
gulp.task 'templates', ->
  gulp
    .src('_templates/**/*.jade')
    .pipe($.jade({ pretty: true }))
    .pipe(gulp.dest('./'))

# Build
# Executes 'jekyll build' command after the tasks above are finished
# The configuration for the Jekyll build is in _config.yml file
gulp.task 'build', ['clean', 'templates', 'styles', 'scripts'], ->
  gulp
    .src('./')
    .pipe($.exec('jekyll build'))
    .pipe($.notify('Jekyll site built'))

# Serve
# Executes 'jekyll serve' command after the tasks above are finished
gulp.task 'serve', ['clean', 'templates', 'styles', 'scripts'], ->
  gulp
    .src('./')
    .pipe($.notify('Blog ready on http://0.0.0.0:4000'))
    .pipe($.exec('jekyll serve'))

# Watch
# Executes 'build' task, Jekyll with watch option enabled and also
# it watches for changes in the styles, scripts and markup
gulp.task 'watch', ->
  gulp
    .src('./')
    .pipe($.exec('jekyll serve -w'))

  gulp.watch('_scss/**/*.scss', ['styles'])
  gulp.watch('_scripts/**/*.coffee', ['scripts'])
  gulp.watch('_templates/**/*.jade', ['templates'])

# Default
gulp.task 'default', ->
  gulp.start('watch')