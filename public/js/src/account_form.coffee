angular.module('rdio-sync', ['ngRoute', 'ngResource'])
.factory 'socket', ($rootScope) ->
  socket = io.connect 'http://localhost:3003'
  return {}
  # return {
  #   on: (eventName, callback) ->
  #     socket.on eventName, ->
  #       args = arguments;
  #       $rootScope.$apply ->
  #         callback.apply socket, args
  #   emit: (eventName, data, callback) ->
  #     socket.emit eventName, data, ->
  #       args = arguments
  #       $rootScope.$apply ->
  #         callback?.apply socket, args
  # }

.config ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode true

  $routeProvider
    .when '/',
      templateUrl: '/landing.html'
    .when '/accounts/:id',
      controller:  'AcountsController'
      templateUrl: '/account.html'
    .otherwise redirectTo: '/'

.controller 'AcountsController', ($scope, $resource, $routeParams, socket) ->
  Account = $resource '/api/v1/accounts/:id', {id: '@id'}, update: { method: 'PUT', isArray: false }
  $scope.loading = true
  $scope.account = Account.get id: $routeParams.id, -> $scope.loading = false

  # socket.on 'account:update', (data) ->
  #   if data.account_id == $scope.account.id
  #     $scope.account.status = data.status

  $scope.syncAccount = ->
    $scope.loading = true
    $scope.account.sync_now = true
    $scope.account.$update ->
      $scope.loading = false
      $scope.account.sync_now = false


  $scope.updateAccount = ->
    $scope.loading = true
    $scope.account.$update -> $scope.loading = false

