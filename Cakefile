{spawn}      = require 'child_process'
{watchTree}  = require 'watch'
_            = require 'underscore'
CoffeeScript = require 'coffee-script'

TEST_ARGS = [
  "--compilers", "coffee:coffee-script/register"
  "--require", "coffee-script"
  "--require", "test/test_helper.coffee"
  "--recursive"
  "--growl"
]

COFFEE_ARGS = [
  '--compile'
  '--join', 'public/js/package.js'
  'src/client'
]

run_tests = (arg1) ->
  return if _.isObject arg1
  spawn 'mocha', TEST_ARGS, stdio: 'inherit'

compile_client = (coffee_args) ->
  spawn 'coffee', coffee_args, stdio: 'inherit'

task 'build', 'compile the client side coffee script', ->
  compile_client COFFEE_ARGS

task 'test', 'rebuild the project', (options) ->
  run_tests()

task 'dev', 'watch sources and run tests', ->
  nodemon     = require 'nodemon'
  nodemon
    ext: 'coffee'
    script: 'src/application.coffee'
    verbose: true

  compile_client _.union(['--watch', '--map'], COFFEE_ARGS)

  watchTree 'src', run_tests
  watchTree 'test', run_tests
  run_tests()
