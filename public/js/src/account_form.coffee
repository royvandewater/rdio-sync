angular.module('rdio-sync', ['ngRoute', 'ngResource'])
.factory 'socket', ($rootScope) ->
  socket = io.connect 'http://localhost:3003'
  return {
    on: (eventName, callback) ->
      socket.on eventName, ->
        args = arguments;
        $rootScope.$apply ->
          callback.apply socket, args
    emit: (eventName, data, callback) ->
      socket.emit eventName, data, ->
        args = arguments
        $rootScope.$apply ->
          callback?.apply socket, args
  }

.config ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode true

  $routeProvider
    .when '/',
      templateUrl: '/landing.html'
    .when '/account',
      controller:  'AcountsController'
      templateUrl: '/account.html'
    .otherwise redirectTo: '/'

.controller 'AcountsController', ($scope, $resource, $routeParams, socket) ->
  Account = $resource '/api/v1/account', {}, update: { method: 'PUT', isArray: false }
  $scope.loading = true
  $scope.account = Account.get {}, -> $scope.loading = false
  $scope.messages =
    'save:start'                    : 'Saving account.'
    'unset_all_synced_tracks:start' : 'Unsetting all synced tracks.'
    'set_tracks_to_sync:start'      : 'Setting tracks to sync.'

  socket.on 'account:update', (data) ->
    if data.id == $scope.account.id
      $scope.account.status = data.status

  $scope.syncAccount = ->
    $scope.loading = true
    $scope.account.sync_now = true
    $scope.account.$update ->
      $scope.loading = false
      $scope.account.sync_now = false


  $scope.updateAccount = ->
    $scope.loading = true
    $scope.account.$update -> $scope.loading = false

