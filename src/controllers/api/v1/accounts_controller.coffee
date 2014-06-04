Account = require '../../../models/account'

class AccountsController
  constructor: (options={}) ->
    Account.table = options.account_table

  show: (request, response) =>
    account = new Account id: request.params.account_id
    account.fetch =>
      response.send account.toJSON()

module.exports = AccountsController
