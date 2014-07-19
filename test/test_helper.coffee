angular   = require 'angular'
chai      = require 'chai'
sinon     = require 'sinon'

chai.use require 'sinon-chai'

angular.module 'rdio-sync', []
global.angular   = angular

global.expect    = chai.expect
global.sinon     = sinon


global.inject = (name, dependencies) ->
  $injector   = angular.injector ['ng', 'rdio-sync']
  $controller = $injector.get '$controller'
  $rootScope  = $injector.get('$rootScope');
  $scope      = $rootScope.$new();

  $controller name, dependencies
