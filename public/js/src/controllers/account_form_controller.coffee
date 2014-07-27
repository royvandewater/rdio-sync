angular.module('rdio-sync')
       .controller 'AccountFormController', ($scope, AccountService) ->

  $scope.account = {loading: true}
  AccountService.getAccount().success (account) ->
    $scope.account = account

  $scope.syncAccount = ->
    $scope.account.loading = true
    AccountService.syncAccount($scope.account).success ->
      $scope.account.loading = false

  $scope.updateAccount = ->
    $scope.account.loading = true
    AccountService.updateAccount($scope.account).success ->
      $scope.account.loading = false
