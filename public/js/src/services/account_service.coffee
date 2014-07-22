angular.module('rdio-sync')
      .service 'AccountService', ($http) ->

  getAccount = ->
    $http.get '/api/v1/account'

  updateAccount = (data) ->
    $http.put '/api/v1/account', data

  return {
    getAccount:    getAccount
    updateAccount: updateAccount
  }
