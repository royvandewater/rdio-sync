angular.module('rdio-sync', ['ngRoute', 'ngResource'])

.config ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode true

  $routeProvider
    .when '/',
      templateUrl: '/landing.html'
    .when '/accounts/:accountId',
      controller:  'AcountsController'
      templateUrl: '/account.html'
    .otherwise redirectTo: '/'

.controller 'AcountsController', ($scope, $resource, $routeParams) ->
  Account = $resource '/api/v1/accounts/:accountId', accountId: '@id'
  $scope.account = Account.get accountId: $routeParams.accountId
