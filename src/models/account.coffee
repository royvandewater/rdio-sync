_        = require 'lodash'
async    = require 'async'
Rdio     = require '../../lib/rdio'
RdioSync = require './rdio_sync'
Backbone = require 'backbone'

class Account
  constructor: (attributes, options={}) ->
    @table = options.table ? new Account.table()
    @set(attributes ? {}) unless options.table?

  destroy: (callback=->) =>
    @table.remove callback

  fetch: (callback=->) =>
    Account.table.get @id, (error, @table) =>
      callback error, this

  get: (attribute) =>
    @table[attribute]

  rdio: =>
    @_rdio ||= new RdioSync(global.RDIO_TOKEN, @rdio_token())

  rdio_token: =>
    [@get('rdio_key'), @get('rdio_secret')]

  save: (callback=->) =>
    @table.id = @id
    @table.save (error, table) =>
      @id = parseInt(@table.id)
      callback error, this

  set: (attributes) =>
    @id = attributes.id if attributes.id?
    _.each attributes, (value, key) =>
      @table[key] = value

  sync: (callback=->) =>
    async.series [
      @_unset_all_synced_tracks
      @_set_tracks_to_sync
      @_update_last_synced_at
    ], (error) =>
      if error?
        console.log "Account failed to sync. account.id: '#{@id}'"
        console.log error
      callback error

  toJSON: =>
    _.clone @table

  update_attributes: (attributes, callback=->) =>
    @set attributes
    @save callback

  _get_synced_track_keys: (callback=->) =>
    @rdio().get_synced_tracks (error, synced_tracks) =>
      callback error, _.pluck(synced_tracks, 'key')

  _get_tracks_to_sync_keys: (callback=->) =>
    @_tracks_to_sync (error, tracks_to_sync) =>
      callback error, _.pluck(tracks_to_sync, 'key')

  _mixed_tracks: (count, callback=->) =>
    half_count = count / 2
    @_most_played_tracks half_count, (error, most_played_tracks) =>
      return callback error if error?
      @_recently_added_tracks half_count, (error, recently_added_tracks) =>
        return callback error if error?
        callback error, _.union(most_played_tracks, recently_added_tracks)

  _most_played_tracks: (count, callback=->) =>
    @rdio().most_played_tracks count, callback

  _recently_added_tracks: (count, callback=->) =>
    @rdio().recently_added_tracks count, callback

  _set_tracks_to_sync: (callback=->) =>
    @_get_tracks_to_sync_keys (error, tracks_to_sync_keys) =>
      return callback error if error?
      @rdio().set_sync true, tracks_to_sync_keys, =>
        callback.apply this, arguments

  _tracks_to_sync: (callback=->) =>
    count = @get('number_of_tracks_to_sync') ? 0

    switch @get 'sync_type'
      when 'playCount' then @_most_played_tracks count, callback
      when 'dateAdded' then @_recently_added_tracks count, callback
      when 'both'      then @_mixed_tracks count, callback
      else throw "Invalid sync_type: #{sync_type}"

  _unset_all_synced_tracks: (callback=->) =>
    @_get_synced_track_keys (error, synced_track_keys) =>
      callback error if error?
      @rdio().set_sync false, synced_track_keys, =>
        callback.apply this, arguments

  _update_last_synced_at: (callback=->) =>
    @update_attributes {last_synced_at: new Date}, =>
      callback.apply this, arguments

  @find_by_rdio_key: (rdio_key, callback=->) =>
    Account.table.find {rdio_key: rdio_key}, (error, accounts) =>
      account_table = _.first accounts

      if account_table
        account = new Account({}, table: account_table)

      callback error, account

  @where: (filters, callback=->) =>
    Account.table.find filters, (error, accounts) =>
      callback error, _.map(accounts, (account) -> new Account({}, table: account))

  @sync_all: (callback=->) =>
    Account.where auto_sync: true, (error, accounts) ->
      return callback(error) if error?
      async.each accounts, (account, cb=->) ->
        account.sync (error) ->
          cb error
      , callback

  @start_rdio_initialization: (host, callback) =>
    rdio = new Rdio global.RDIO_TOKEN
    account = new Account
    account.save =>
      url  = "http://#{host}/accounts/#{account.id}/login"

      rdio.beginAuthentication url, (error, auth_url) =>
        return callback error if error?

        account.set rdio_key: rdio.token[0], rdio_secret: rdio.token[1]
        account.save (error) =>
          callback error, auth_url

  @complete_rdio_authentication: (id, oauth_verifier, callback=->) =>
    account = new Account id: id
    account.fetch (error) =>
      return callback error if error?

      rdio = new Rdio global.RDIO_TOKEN, account.rdio_token()
      rdio.completeAuthentication oauth_verifier, (error) =>
        return callback error if error?

        rdio.call 'currentUser', (error, data) =>
          return callback error if error?

          username = data.result.url.match(/\/(\w+)\/$/)[1]

          Account.where username: username, (error, accounts) =>
            return callback error if error?

            old_account = _.first accounts
            if old_account
              account.destroy()
              account = old_account

            account.set
              rdio_key:    rdio.token[0]
              rdio_secret: rdio.token[1]
              username:    username
            account.save (error) =>
              callback error, account

  @schema:
    username:      {type: 'text'}
    rdio_key:      {type: 'text'}
    rdio_secret:   {type: 'text'}
    sync_type:     {type: 'text', defaultValue: 'playCount'}
    auto_sync:     {type: 'boolean', defaultValue: false, required: true}
    number_of_tracks_to_sync: {type: 'number', defaultValue: 200}
    last_synced_at: {type: 'date', time: true}

module.exports = Account
