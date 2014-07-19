require '../../../public/js/src/controllers/account_form_controller.coffee'

describe 'AccountFormController', ->
  beforeEach ->
    @fakeAccountService = new FakeAccountService
    @scope = inject('$rootScope').$new()
    @sut = injectController 'AccountFormController', {'$scope': @scope, AccountService: @fakeAccountService}

  it 'should instantiate', ->
    expect(@sut).to.exist

  it 'should call get on the accountService', ->
    expect(@fakeAccountService.getAccount.called).to.be.true

  describe 'when the getAccount promise resolves', ->
    beforeEach ->
      @fakeAccountService.getAccount.resolve({thing: true})

    it 'should attach the account to the $scope', ->
      expect(@scope.account).to.deep.equal({thing: true})

class FakeAccountService
  getAccount: ->
    @getAccount.called = true
    @getAccount.resolve = => @getAccountCallback.apply this, arguments
    return {then: (@getAccountCallback=->) =>}

