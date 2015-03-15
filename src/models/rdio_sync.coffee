_    = require 'lodash'
Rdio = require '../../lib/rdio'

class RdioSync
  constructor: (app_token, user_token) ->
    @_rdio = new Rdio app_token, user_token

  get_synced_tracks: (callback=->) =>
    @_get_synced_tracks 0, [], callback

  most_played_tracks: (count, callback=->) =>
    options = {sort: 'playCount', count: count}
    @_call 'getTracksInCollection', options, (error, response) =>
      callback error, response?.result

  recently_added_tracks: (count, callback=->) =>
    options = {sort: 'dateAdded', count: count}
    @_call 'getTracksInCollection', options, (error, response) =>
      callback error, response?.result

  set_sync: (sync, keys=[], callback=->) =>
    keys_string = keys.join ','
    @_call 'setAvailableOffline', {offline: sync, keys: keys_string}, callback

  _call: (method, options={}, callback=->) =>
    @_rdio.call method, options, callback

  _get_synced_tracks: (batch=0, synced_tracks=[], callback=->) =>
    @_synced_tracks_in_batch batch, (error, synced_tracks_in_batch) =>
      return callback(error) if error?
      return callback(error, synced_tracks) if _.isEmpty synced_tracks_in_batch
      return @_get_synced_tracks(batch + 1, _.union(synced_tracks, synced_tracks_in_batch), callback)

  _synced_tracks_in_batch: (batch, callback=->) =>
    count = 500
    options = {start: (batch * count), count: count, extras: 'playCount'}
    @_call 'getOfflineTracks', options, (error, response) =>
      return callback(error) if error?
      callback error, response.result

module.exports = RdioSync
