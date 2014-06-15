class window.AccountFormView extends Backbone.View
  template: JST['account_form']

  initialize: =>
    @listenTo @model, 'change', @render

  context: =>
    model: @model.toJSON()

  render: =>
    @$el.html @template @context()

  events:
    'submit form': 'submit'

  submit: ($event) =>
    $event.preventDefault()
    $event.stopPropagation()
    @model.set @values()
    @model.save()

  values: =>
    number_of_tracks_to_sync: @$('number-of-tracks').val()
    sync_type: @$('sync_type').val()
    auto_sync: @$('auto_sync').val()