angular.module('rdio-sync')
.controller 'AccountFormController', ($scope, AccountService) ->

  AccountService.getAccount (account) ->
    $scope.account = account

