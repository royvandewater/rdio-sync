AccountsController = require '../../src/controllers/accounts_controller'

describe 'AccountsController', ->
  describe 'initialize', ->
    it 'should instantiate', ->
      expect(new AccountsController).to.exist

  describe 'create', ->
    beforeEach ->
      @sut = new AccountsController

    it 'should be a function', ->
      expect(@sut).to.respondTo 'create'
