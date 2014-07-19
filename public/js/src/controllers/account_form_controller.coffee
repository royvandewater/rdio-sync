angular.module('rdio-sync')
.controller 'AccountFormController', ($scope, AccountService) ->

  AccountService.getAccount().then (account) ->
    $scope.account = account

