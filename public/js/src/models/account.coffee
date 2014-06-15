class window.Account extends Backbone.Model
  urlRoot: '/api/v1/accounts'

  initialize: =>
    @on 'request', =>
      @set loading: true

    @on 'sync', =>
      @set loading: false

