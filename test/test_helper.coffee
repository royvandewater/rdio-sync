angular   = require 'angular'
chai      = require 'chai'
sinon     = require 'sinon'

chai.use require 'chai-as-promised'
chai.use require 'sinon-chai'

angular.module 'rdio-sync', []
global.angular   = angular

global.expect    = chai.expect
global.sinon     = sinon


global.inject = (name) ->
  $injector   = angular.injector ['ng', 'rdio-sync']
  $injector.get name

global.injectController = (name, dependencies={}) ->
  # $rootScope  = $injector.get '$rootScope'
  # $scope      = $rootScope.$new();

  $controller = inject '$controller'
  $controller name, dependencies
