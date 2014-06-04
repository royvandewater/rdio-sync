Account = require '../models/account'
eco     = require 'eco'
fs      = require 'fs'

class AccountsController
  constructor: (options={}) ->
    Account.table = options.account_table
    @show_template = eco.compile fs.readFileSync("#{__dirname}/../templates/accounts/show.eco", encoding: "utf8")

  show: (request, response) =>
    account = new Account id: request.params.account_id
    account.fetch =>
      response.send @show_template account.toJSON()

  create: (request, response) =>
    account = new Account
    account.start_rdio_initialization request.headers.host, (error, auth_url) =>
      response.redirect auth_url

  login: (request, response) =>
    account = new Account id: request.params.account_id
    account.fetch =>
      account.complete_rdio_authentication request.query.oauth_verifier, (error) =>
      throw error if error?
      url = "http://#{request.headers.host}/accounts/#{account.id}"
      response.redirect url


module.exports = AccountsController
