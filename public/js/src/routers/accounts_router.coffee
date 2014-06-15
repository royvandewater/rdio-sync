class AccountsRouter extends Backbone.Router
  routes:
    'accounts/:id': 'show'

  show: (account_id) =>
    @account = new Account id: account_id
    @account.fetch()
    view = new AccountFormView model: @account
    $('#main-content').html view.render()

new AccountsRouter
