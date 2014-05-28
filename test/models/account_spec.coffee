{Account,schema} = require '../../src/models/account'
orm     = require 'orm'

describe 'Account', ->
  beforeEach (callback=->) ->
    orm.connect "mysql://root:@localhost/rdio_sync_test", (err, @db) =>
      throw err if err?
      Account.table = @db.define 'accounts', schema
      @db.sync callback

  afterEach (callback=->) ->
    Account.table.drop callback

  describe 'instantiate', ->
    it 'should remember its attributes', ->
      @sut = new Account username: 'royvandewater'
      expect(@sut.get 'username').to.equal 'royvandewater'

  describe 'save', ->
    it 'should set the id on the account', (callback=->) ->
      @sut = new Account
      @sut.save =>
        throw error if error?
        expect(@sut.id).to.exist
        callback()

  describe 'fetch', ->
    it 'should fetch the model attributes', (callback=->) ->
      @sut = new Account username: 'somethingelse'
      @sut.save (error) =>
        throw error if error?

        @sut = new Account id: @sut.id
        @sut.fetch (error) =>
          throw error if error?
          expect(@sut.get 'username').to.equal 'somethingelse'
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

