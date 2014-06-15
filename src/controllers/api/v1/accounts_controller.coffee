Account = require '../../../models/account'

class AccountsController
  constructor: (options={}) ->
    Account.table = options.account_table

  show: (request, response) =>
    account = new Account id: request.params.account_id
    account.fetch =>
      response.send account.toJSON()

  update: (request, response) =>
    account = new Account id: request.params.account_id
    account.fetch =>
      account.set
        auto_sync:                request.body.auto_sync
        number_of_tracks_to_sync: request.body.number_of_tracks_to_sync
        sync_type:                request.body.sync_type
      account.save (error, account) =>
        return response.send error, 422 if error?
        response.send null, 204

module.exports = AccountsController
