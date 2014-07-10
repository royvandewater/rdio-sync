Account = require '../../../models/account'

class AccountsController
  constructor: (options={}) ->
    Account.table = options.account_table
    @io = options.io

  show: (request, response) =>
    @io.emit 'account:update', {account_id: 8, status: 'Fetching account.'}
    account = new Account id: request.params.account_id
    account.fetch (error, model) =>
      return response.send(error, 404) if error?
      response.send account.toJSON()

  update: (request, response) =>
    @io.emit 'account:update', {account_id: 8, status: 'Fetching account.'}
    account = new Account id: request.params.account_id
    account.fetch =>
      @io.emit 'account:update', {account_id: 8, status: 'Updating account.'}
      account.set @_params request
      account.save (error, account) =>
        return response.send(error, 422) if error?
        return response.send null, 204 unless request.body.sync_now

        @io.emit 'account:update', {account_id: 8, status: 'Syncing with rdio.'}
        account.sync (error) =>
          return response.send(error, 404) if error?
          return response.send null, 204

  _params: (request) =>
    auto_sync:                request.body.auto_sync
    number_of_tracks_to_sync: request.body.number_of_tracks_to_sync
    sync_type:                request.body.sync_type

module.exports = AccountsController
