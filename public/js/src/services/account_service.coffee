angular.module('rdio-sync')
      .service 'AccountService', ($http) ->

  getAccount = ->
    $http.get '/api/v1/account'

  return {
    getAccount: getAccount
  }
