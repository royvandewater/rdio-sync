require 'coffee-script/register'
{spawn}        = require 'child_process'
{watchTree}    = require 'watch'
_              = require 'underscore'
moment         = require 'moment'
CoffeeCompiler = require './src/util/coffee_compiler'
Account        = require './src/models/account'
orm            = require 'orm'


coffee_compiler = new CoffeeCompiler
  map_output_file:        'public/js/package.map'
  javascript_output_file: 'public/js/package.js'

task 'sync', 'syncs all accounts marked for auto sync', ->
  orm.connect "mysql://root:@localhost/rdio_sync", (error, database) ->
    throw error if error?
    global.RDIO_TOKEN = [process.env['RDIO_KEY'], process.env['RDIO_SECRET']]
    Account.table = database.define 'accounts', Account.schema
    Account.sync_all (error) ->
      throw error if error?
      process.exit()

task 'build', 'compile client side assets', ->
  coffee_compiler.compile_directory 'public/js/src'

task 'test', 'run all the tests', ->
  run_tests()

task 'dev', 'watch sources and run tests', ->
  watchTree 'public/js/src', coffee_compiler.compile_file
  coffee_compiler.compile_directory 'public/js/src'

  watchTree 'src', run_tests
  watchTree 'test', run_tests
  watchTree 'public/js/src', run_tests
  run_tests()

  nodemon     = require 'nodemon'
  nodemon
    ext: 'coffee'
    script: 'src/application.coffee'
    ignore: ['public', 'node_modules']
    verbose: true

run_tests_now = (arg1) ->
  return if _.isObject arg1
  TEST_ARGS = [
    # 'debug'
    '--compilers', 'coffee:coffee-script/register'
    '--require', 'coffee-script'
    '--require', 'test/test_helper.coffee'
    '--recursive'
    '--growl'
    '--reporter', 'spec'

  ]
  spawn 'mocha', TEST_ARGS, stdio: 'inherit'

run_tests = _.throttle run_tests_now, 1000, trailing: false
