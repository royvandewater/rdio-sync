require '../../../public/js/src/controllers/account_form_controller.coffee'

describe 'AccountFormController', ->
  beforeEach ->
    @fakeAccountService = new FakeAccountService
    @sut = inject 'AccountFormController', {AccountService: @fakeAccountService}

  it 'should instantiate', ->
    expect(@sut).to.exist

  it 'should call get on the accountService', ->
    expect(@fakeAccountService.get.called).to.be.true

class FakeAccountService
  get: ->
    @get.called = true

