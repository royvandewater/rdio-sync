require 'coffee-script/register'
{spawn}      = require 'child_process'
{watchTree}  = require 'watch'
_            = require 'underscore'
CoffeeScript = require 'coffee-script'
fs           = require 'fs'
mapcat       = require 'mapcat'
moment       = require 'moment'
Walk         = require 'walk'
EcoUtil      = require './src/util/eco_util'

TEST_ARGS = [
  "--compilers", "coffee:coffee-script/register"
  "--require", "coffee-script"
  "--require", "test/test_helper.coffee"
  "--recursive"
  "--growl"
]

COFFEE_ARGS = [
  '--compile'
  '--map'
  'public/js/src'
]

task 'build', 'compile the client side coffee script', ->
  compile_client COFFEE_ARGS, ->
    compile_templates ->
      concatinate_javascript()

task 'test', 'rebuild the project', (options) ->
  run_tests()

task 'dev', 'watch sources and run tests', ->
  nodemon     = require 'nodemon'
  nodemon
    ext: 'coffee'
    script: 'src/application.coffee'
    verbose: true

  compile_client _.union(['--watch'], COFFEE_ARGS)
  compile_templates()
  watchTree 'public/js/src/templates', compile_templates

  watchTree 'src', run_tests
  watchTree 'test', run_tests
  watchTree 'public/js/src', concatinate_javascript
  run_tests()

concatinate_javascript = ->
  map_files = []
  walker = Walk.walk 'public/js/src'
  walker.on 'file', (root, fileStats, next) ->
    return next() unless /\.map$/.test fileStats.name
    console.log "found: #{root}#{fileStats.name}"
    map_files.push "#{root}/#{fileStats.name}"
    next()

  walker.on 'end', ->
    mapcat.cat map_files, 'public/js/package.js', 'public/js/package.map'
    console.log "concatinated to 'public/js/package.js'"

run_tests = (arg1) ->
  return if _.isObject arg1
  spawn 'mocha', TEST_ARGS, stdio: 'inherit'

compile_client = (coffee_args, callback=->) ->
  compiler = spawn 'coffee', coffee_args, stdio: 'inherit'
  compiler.on 'close', callback

compile_templates = (callback=->) =>
  output = ''

  walker = Walk.walk 'public/js/src/templates/'
  walker.on 'file', (root, fileStats, next) =>
    return next() unless /\.eco$/.test fileStats.name
    path = "#{root}#{fileStats.name}"
    name = fileStats.name[0...-4]
    EcoUtil.compile path, 'JST', name, (error, compiled_template) =>
      output += compiled_template
      next()

  walker.on 'end', =>
    fs.writeFile 'public/js/templates.js', output, =>
      console.log "#{moment().format 'hh:mm:ss'} - compiled public/js/templates.js"
      callback?()


