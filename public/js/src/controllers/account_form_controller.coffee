angular.module('rdio-sync')
.controller 'AccountFormController', (AccountService) ->
  AccountService.get()

