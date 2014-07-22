chai      = require 'chai'
sinon     = require 'sinon'

chai.use require 'sinon-chai'

global.expect    = chai.expect
global.sinon     = sinon

# angular   = require 'angular'
# angular.module 'rdio-sync', []
# global.angular   = angular
# global.initializeInjector = ->
#   global.$injector = angular.injector ['ng', 'rdio-sync']
#   global.inject    = $injector.invoke

# global.injectModule = (name) ->
#   $injector.get name

# global.injectController = (name, dependencies={}) ->
#   $controller = injectModule '$controller'
#   $controller name, dependencies

# global.injectService = (name, dependencies={}) ->
#   injectModule name
