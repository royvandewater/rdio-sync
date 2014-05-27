AccountsController = require '../../src/controllers/accounts_controller'

describe 'AccountsController', ->
  describe 'initialize', ->
    it 'should instantiate', ->
      expect(new AccountsController).to.be
