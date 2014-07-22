angular.module('rdio-sync')
       .controller 'AccountFormController', ($scope, AccountService) ->

  AccountService.getAccount().then (account) ->
    $scope.account = account

  $scope.syncAccount = ->
    AccountService.syncAccount $scope.account

  $scope.updateAccount = ->
    AccountService.updateAccount $scope.account

