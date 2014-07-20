angular.module('rdio-sync')
.controller 'AccountFormController', ($scope, AccountService) ->

  AccountService.getAccount().then (account) ->
    $scope.account = account

  $scope.updateAccount = ->
    AccountService.updateAccount $scope.account

