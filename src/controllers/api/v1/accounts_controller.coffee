Account = require '../../../models/account'

class AccountsController
  constructor: (options={}) ->
    Account.table = options.account_table

  show: (request, response) =>
    @_fetch_account request, (error, account) =>
      return response.send(error, 404) if error?
      response.send account.toJSON()

  update: (request, response) =>
    @_fetch_account request, (error, account) =>
      return response.send(error, 404) if error?

      account.set @_params request
      account.save (error, account) =>
        return response.send(error, 422) if error?
        return response.send null, 204 unless request.body.sync_now

        account.sync (error) =>
          return response.send(error, 404) if error?
          return response.send null, 204

  _fetch_account: (request, callback=->) =>
    rdio_key = request.cookies.get('rdio_key')

    Account.find_by_rdio_key rdio_key, (error, account) =>
      account?.on 'all', (the_event) =>

      callback error, account

  _params: (request) =>
    auto_sync:                request.body.auto_sync
    number_of_tracks_to_sync: request.body.number_of_tracks_to_sync
    sync_type:                request.body.sync_type

module.exports = AccountsController
