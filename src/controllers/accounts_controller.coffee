Account = require '../models/account'
Rdio    = require '../../lib/rdio'
eco     = require 'eco'
fs      = require 'fs'

class AccountsController
  constructor: (options={}) ->
    @rdio_token = options.rdio_token
    Account.table = options.account_table
    @show_template = eco.compile fs.readFileSync("#{__dirname}/../templates/accounts/show.eco", encoding: "utf8")

  show: (request, response) =>
    account = new Account id: request.params.account_id
    account.fetch =>
      response.send @show_template account.toJSON()

  create: (request, response) =>
    rdio = new Rdio @rdio_token
    account = new Account
    account.save =>
      host = request.headers.host
      url  = "#{host}/accounts/#{account.id}/login"

      rdio.beginAuthentication url, (error, auth_url) =>
        throw error if error?
        account.set rdio_key: rdio.token[0], rdio_secret: rdio.token[1]

        account.save (error) =>
          throw error if error?
          response.redirect auth_url

  login: (request, response) =>
    account = new Account id: request.params.account_id
    account.fetch =>
      rdio = new Rdio @rdio_token, account.rdio_token()
      rdio.completeAuthentication request.query.oauth_verifier, (error) =>
        throw error if error?
        rdio.call 'currentUser', (error, data) =>
          throw error if error?
          username = data.result.url.match(/\/(\w+)\/$/)[1]

          account.set
            rdio_key:    rdio.token[0]
            rdio_secret: rdio.token[1]
            username:    username
          account.save (error) =>
            throw error if error?
            url = "http://#{request.headers.host}/accounts/#{account.id}"
            response.redirect url

module.exports = AccountsController
