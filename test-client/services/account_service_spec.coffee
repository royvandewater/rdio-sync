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
      it 'should call http.get with the correct url and pass the response', (done=->) ->
        @httpBackend.expectGET('/api/v1/account').respond {foo: 'bar'}
        @sut.getAccount().success (account) =>
          expect(account).to.deep.equal {foo: 'bar'}
          done()
        @httpBackend.flush()





