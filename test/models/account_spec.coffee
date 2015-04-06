Account = require '../../src/models/account'
orm     = require 'orm'

describe 'Account', ->
  beforeEach (callback=->) ->
    orm.connect "mysql://root:@localhost/rdio_sync_test", (err, @db) =>
      throw err if err?
      Account.table = @db.define 'accounts', Account.schema
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
    describe 'when some attributes are saved', ->
      beforeEach (callback) ->
        @attributes =
          username: 'somethingelse'
          rdio_key: 'foo'
          rdio_secret: 'bar'
          number_of_tracks_to_sync: 2
          auto_sync: true
          last_synced_at: new Date('2014-05-04')
          sync_type: 'both'

        @sut = new Account _.clone(@attributes)
        @sut.save callback

      it 'should fetch the attributes', (callback=->) ->
        @sut = new Account id: @sut.id
        @sut.fetch (error) =>
          throw error if error?

          _.each @attributes, (value, key) =>
            expect(@sut.get key).to.deep.equal value
          callback()

  describe 'toJSON', ->
    beforeEach ->
      @attributes =
        id: 4
        username: 'random'
        rdio_key: 'key'
        rdio_secret: 'secret'
        number_of_tracks_to_sync: 3
        auto_sync: false
        last_synced_at: null
        sync_type: 'playCount'
      @sut = new Account @attributes

    it 'should include the all the attributes', ->
      expect(@sut.toJSON()).to.deep.equal @attributes

    it 'should not let me change the original', ->
      new_attributes = @sut.toJSON()
      new_attributes.username = 'modnar'
      expect(@sut.toJSON().username).to.equal 'random'
