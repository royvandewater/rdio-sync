require 'coffee-script/register'
{spawn}        = require 'child_process'
{watchTree}    = require 'watch'
_              = require 'underscore'
moment         = require 'moment'
EcoCompiler    = require './src/util/eco_compiler'
CoffeeCompiler = require './src/util/coffee_compiler'
Account        = require './src/models/account'
orm            = require 'orm'


template_compiler = new EcoCompiler
  output_file: 'public/js/templates.js'

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
  template_compiler.compile_directory 'public/js/src/templates'

task 'test', 'run all the tests', ->
  run_tests()

task 'dev', 'watch sources and run tests', ->
  watchTree 'public/js/src', coffee_compiler.compile_file
  coffee_compiler.compile_directory 'public/js/src'

  watchTree 'public/js/src/templates', template_compiler.compile_file
  template_compiler.compile_directory 'public/js/src/templates'

  watchTree 'src', run_tests
  watchTree 'test', run_tests
  run_tests()

  nodemon     = require 'nodemon'
  nodemon
    ext: 'coffee'
    script: 'src/application.coffee'
    verbose: true


run_tests = (arg1) ->
  return if _.isObject arg1
  TEST_ARGS = [
    '--compilers', 'coffee:coffee-script/register'
    '--require', 'coffee-script'
    '--require', 'test/test_helper.coffee'
    '--recursive'
    '--growl'
    '--reporter', 'spec'

  ]
  spawn 'mocha', TEST_ARGS, stdio: 'inherit'

# compile_templates = EcoUtil.create_compiler 'public/js/src/templates/', 'public/js/templates.js'
# compile_coffeescript = CoffeeUtil.create_compiler
#                           directory:  'public/js/src'
#                           javascript: 'public/js/package.js'
#                           map_file:   'public/js/package.map'
#                           done: ->
#                             console.log "#{moment().format 'hh:mm:ss'} - compiled public/js/package.js"
