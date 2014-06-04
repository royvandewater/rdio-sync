_ = require 'underscore'
Rdio    = require '../../lib/rdio'

class Account
  constructor: (attributes, options={}) ->
    @table = new Account.table()
    @set(attributes ? {})

  fetch: (callback=->) =>
    Account.table.get @id, (error, @table) =>
      callback error, this

  get: (attribute) =>
    @table[attribute]

  rdio_token: =>
    [@get('rdio_key'), @get('rdio_secret')]

  save: (callback=->) =>
    @table.save (error, table) =>
      @id = @table.id
      callback error, this

  set: (attributes) =>
    @id = attributes.id if attributes.id?
    _.each attributes, (value, key) =>
      @table[key] = value

  toJSON: =>
    _.clone @table

  start_rdio_initialization: (host, callback=->) =>
    rdio = new Rdio global.RDIO_TOKEN
    @save =>
      url  = "#{host}/accounts/#{@id}/login"

      rdio.beginAuthentication url, (error, auth_url) =>
        return callback error if error?
        @set rdio_key: rdio.token[0], rdio_secret: rdio.token[1]

        @save (error) =>
          callback error, auth_url

  complete_rdio_authentication: (oauth_verifier, callback=->) =>
    rdio = new Rdio global.RDIO_TOKEN, @rdio_token()
    rdio.completeAuthentication oauth_verifier, (error) =>
      return callback error if error?

      rdio.call 'currentUser', (error, data) =>
        return callback error if error?

        @set
          rdio_key:    rdio.token[0]
          rdio_secret: rdio.token[1]
          username:    data.result.url.match(/\/(\w+)\/$/)[1]
        @save callback

  @schema:
    username:      {type: 'text'}
    rdio_key:      {type: 'text'}
    rdio_secret:   {type: 'text'}
    session_token: {type: 'text'}
    sync_type:     {type: 'text'}
    auto_sync:     {type: 'boolean'}
    number_of_tracks_to_sync: {type: 'number'}
    last_synced_at: {type: 'date', time: true}
    # last_synced_at: '2014-05-2'
    # sync_type: 'both'
    # session_token: '1234'

module.exports = Account
