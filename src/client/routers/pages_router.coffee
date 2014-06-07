class PagesRouter extends Backbone.Router
  routes:
    '': 'home'

  home: =>
    view = new HomeView
    $('#main-content').html view.render()

new PagesRouter
