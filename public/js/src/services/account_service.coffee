angular.module('rdio-sync')
       .service 'AccountService', ($http) ->

  getAccount: ->
    $http.get '/api/v1/account'

  syncAccount: (data) ->
    @updateAccount _.extend({sync_now: true}, data)

  updateAccount: (data) ->
    $http.put '/api/v1/account', data
