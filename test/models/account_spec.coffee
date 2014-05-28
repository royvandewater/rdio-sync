{Account,schema} = require '../../src/models/account'
orm     = require 'orm'

describe 'Account', ->
  beforeEach (callback=->) ->
    orm.connect "mysql://root:@localhost/rdio_sync_test", (err, @db) =>
      throw err if err?
      @AccountTable = @db.define 'account', schema
      @db.sync callback

  describe 'save', ->
    it 'should set the id on the account', (callback=->) ->
      @sut = new Account {}, table: @AccountTable
      @sut.save =>
        expect(@sut.id).to.exist
        callback()


    # t.string   "username"
    # t.string   "rdio_key"
    # t.string   "rdio_secret"
    # t.datetime "created_at"
    # t.datetime "updated_at"
    # t.integer  "number_of_tracks_to_sync"
    # t.boolean  "auto_sync",                default: false
    # t.datetime "last_synced_at"
    # t.string   "sync_type"
    # t.string   "session_token"

