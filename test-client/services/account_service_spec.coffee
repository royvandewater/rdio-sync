describe 'AccountService', ->
  beforeEach (done=->) ->
    module 'rdio-sync'

    inject ($httpBackend, AccountService) =>
      @httpBackend = $httpBackend
      @sut         = AccountService
      done()

  it 'should exist', ->
    expect(@sut).to.exist

  describe '-> getAccount', ->
    describe 'when getAccount is called', ->
      it 'should send a GET request to the correct url and return response promise', (done=->) ->
        @httpBackend.expectGET('/api/v1/account').respond {foo: 'bar'}
        @sut.getAccount().success (account) =>
          expect(account).to.deep.equal {foo: 'bar'}
          done()
        @httpBackend.flush()

  describe '-> updateAccount', ->
    describe 'when updateAccount is called', ->
      it 'should call http.put', (done) ->
        data = {something: 'else'}
        @httpBackend.expectPUT('/api/v1/account', data).respond 204, null
        @sut.updateAccount(data).success =>
          done()
        @httpBackend.flush()




