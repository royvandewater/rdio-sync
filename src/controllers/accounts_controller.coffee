Account = require '../models/account'
Rdio    = require '../../lib/rdio'

class AccountsController
  constructor: (options={}) ->
    @rdio_token = options.rdio_token
    Account.table = options.account_table

  create: (request, response) =>
    rdio = new Rdio @rdio_token
    account = new Account
    account.save =>
      host = request.headers.host
      url  = "#{host}/accounts/#{account.id}/login"

      rdio.beginAuthentication url, (error, auth_url) =>
        throw error if error?
        account.set rdio_key: rdio.token[0], rdio_secret: rdio.token[1]

        account.save =>
          response.redirect auth_url

  login: (request, response) =>
    account = new Account id: request.params.account_id
    account.fetch =>
      rdio = new Rdio @rdio_token, account.rdio_token()
      rdio.completeAuthentication request.query.oauth_verifier, (error) =>
        throw error if error?

        account.set
          rdio_key:    rdio.token[0]
          rdio_secret: rdio.token[1]
          username:    rdio.username
        account.save =>
          response.send null

module.exports = AccountsController
