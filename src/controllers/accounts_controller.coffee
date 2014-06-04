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
    Account.start_rdio_initialization request.headers.host, (error, auth_url) =>
      throw error if error?
      response.redirect auth_url

  login: (request, response) =>
    account_id = request.params.account_id
    oauth_verifier = request.query.oauth_verifier

    Account.complete_rdio_authentication account_id, oauth_verifier, (error, account) =>
      throw error if error?
      response.redirect "http://#{request.headers.host}/accounts/#{account.id}"



module.exports = AccountsController
