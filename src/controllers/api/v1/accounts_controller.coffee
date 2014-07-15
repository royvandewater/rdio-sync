Account = require '../../../models/account'

class AccountsController
  constructor: (options={}) ->
    Account.table = options.account_table
    @io = options.io

  show: (request, response) =>
    account = new Account id: request.params.account_id
    account.on 'all', (the_event) =>
      @io.emit 'account:update', {id: account.id, status: the_event}

    account.fetch (error, model) =>
      return response.send(error, 404) if error?
      response.send account.toJSON()

  update: (request, response) =>
    account = new Account id: request.params.account_id
    account.on 'all', (the_event) =>
      @io.emit 'account:update', {id: account.id, status: the_event}

    account.fetch =>
      account.set @_params request
      account.save (error, account) =>
        return response.send(error, 422) if error?
        return response.send null, 204 unless request.body.sync_now

        account.sync (error) =>
          return response.send(error, 404) if error?
          return response.send null, 204

  _params: (request) =>
    auto_sync:                request.body.auto_sync
    number_of_tracks_to_sync: request.body.number_of_tracks_to_sync
    sync_type:                request.body.sync_type

module.exports = AccountsController
