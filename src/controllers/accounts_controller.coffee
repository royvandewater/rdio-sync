moment  = require 'moment'
Account = require '../models/account'
Config  = require '../../config'

class AccountsController
  constructor: (options={}) ->
    Account.table = options.account_table

  create: (request, response) =>
    Account.start_rdio_initialization request.headers.host, (error, auth_url) =>
      throw error if error?
      response.redirect auth_url

  login: (request, response) =>
    account_id = request.params.account_id
    oauth_verifier = request.query.oauth_verifier

    Account.complete_rdio_authentication account_id, oauth_verifier, (error, account) =>
      throw error if error?
      response.cookies.set 'rdio_key', account.get('rdio_key'), expires: moment().add('months', 1).toDate(), httpOnly: false
      response.redirect Config.CLIENT_URL

module.exports = AccountsController
