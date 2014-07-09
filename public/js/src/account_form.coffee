angular.module('rdio-sync', ['ngRoute', 'ngResource'])

.config ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode true

  $routeProvider
    .when '/',
      templateUrl: '/landing.html'
    .when '/accounts/:id',
      controller:  'AcountsController'
      templateUrl: '/account.html'
    .otherwise redirectTo: '/'

.controller 'AcountsController', ($scope, $resource, $routeParams) ->
  Account = $resource '/api/v1/accounts/:id', {id: '@id'}, update: { method: 'PUT', isArray: false }
  $scope.loading = true
  $scope.account = Account.get id: $routeParams.id, -> $scope.loading = false

  $scope.syncAccount = ->
    $scope.loading = true
    $scope.account.sync_now = true
    $scope.account.$update ->
      $scope.loading = false
      $scope.account.sync_now = false


  $scope.updateAccount = ->
    $scope.loading = true
    $scope.account.$update -> $scope.loading = false

