describe 'AccountFormController', ->
  beforeEach (done=->) ->
    module 'rdio-sync'

    inject ($controller, $rootScope) =>
      @fakeAccountService = new FakeAccountService
      @scope = $rootScope.$new()
      @sut   = $controller 'AccountFormController', {$scope: @scope, AccountService: @fakeAccountService}
      done()

  it 'should instantiate', ->
    expect(@sut).to.exist

  it 'should call get on the accountService', ->
    expect(@fakeAccountService.getAccount.called).to.be.true

  describe 'when the getAccount promise resolves', ->
    beforeEach ->
      @fakeAccountService.getAccount.resolve({thing: true})

    it 'should attach the account to the $scope', ->
      expect(@scope.account).to.deep.equal({thing: true})

  describe 'when an account is attached to the scope', ->
    beforeEach ->
      @scope.account = {id: 3, sync_type: 'both'}

    describe '-> syncAccount', ->
      beforeEach ->
        @scope.syncAccount()

      it 'should call syncAccount on the AccountService', ->
        expect(@fakeAccountService.syncAccount.called).to.be.true

      it 'should call AccountService.syncAccount with an account', ->
        expect(@fakeAccountService.syncAccount.calledWith).to.deep.equal @scope.account

    describe '-> updateAccount', ->
      beforeEach ->
        @scope.updateAccount()

      it 'should call updateAccount on the AccountService', ->
        expect(@fakeAccountService.updateAccount.called).to.be.true

      it 'should call AccountService.updateAccount with an account', ->
        expect(@fakeAccountService.updateAccount.calledWith).to.deep.equal @scope.account

class FakeAccountService
  getAccount: ->
    @getAccount.called = true
    @getAccount.resolve = => @getAccountCallback.apply this, arguments
    return {success: (@getAccountCallback=->) =>}

  syncAccount: (arg) ->
    @syncAccount.called = true
    @syncAccount.calledWith = arg

  updateAccount: (arg) ->
    @updateAccount.called = true
    @updateAccount.calledWith = arg
