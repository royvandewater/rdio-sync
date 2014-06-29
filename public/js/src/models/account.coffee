class window.Account extends Backbone.Model
  urlRoot: '/api/v1/accounts'

  initialize: =>
    @on 'sync', =>
      @set sync_now: false

