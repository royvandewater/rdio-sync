class window.HomeView extends Backbone.View
  template: JST['home']

  render: =>
    @$el.html @template()
