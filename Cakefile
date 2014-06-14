require 'coffee-script/register'
{spawn}      = require 'child_process'
{watchTree}  = require 'watch'
_            = require 'underscore'
moment       = require 'moment'
EcoCompiler  = require './src/util/eco_util'
CoffeeUtil      = require './src/util/coffee_util'

TEST_ARGS = [
  "--compilers", "coffee:coffee-script/register"
  "--require", "coffee-script"
  "--require", "test/test_helper.coffee"
  "--recursive"
  "--growl"
]

task 'build', 'compile the client side coffee script', ->
  compile_coffeescript ->
    compile_templates()

task 'test', 'rebuild the project', (options) ->
  run_tests()

task 'dev', 'watch sources and run tests', ->
  # nodemon     = require 'nodemon'
  # nodemon
  #   ext: 'coffee'
  #   script: 'src/application.coffee'
  #   verbose: true

  # watchTree 'public/js/src', compile_coffeescript
  # watchTree 'public/js/src/templates', compile_templates
  template_compiler = new EcoCompiler 'public/js/templates.js'
  watchTree 'public/js/src/templates', template_compiler.compile_file
  template_compiler.compile_directory 'public/js/src/templates'

  # watchTree 'src', run_tests
  # watchTree 'test', run_tests
  # run_tests()

run_tests = (arg1) ->
  return if _.isObject arg1
  spawn 'mocha', TEST_ARGS, stdio: 'inherit'

# compile_templates = EcoUtil.create_compiler 'public/js/src/templates/', 'public/js/templates.js'
# compile_coffeescript = CoffeeUtil.create_compiler
#                           directory:  'public/js/src'
#                           javascript: 'public/js/package.js'
#                           map_file:   'public/js/package.map'
#                           done: ->
#                             console.log "#{moment().format 'hh:mm:ss'} - compiled public/js/package.js"
