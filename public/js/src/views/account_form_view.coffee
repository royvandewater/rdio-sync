class window.AccountFormView extends Backbone.View
  template: JST['account_form']

  initialize: =>
    @listenTo @model, 'change', @render
    @listenTo @model, 'sync error', @hide_loading

  context: =>
    model: @model.toJSON()

  render: =>
    @$el.html @template @context()
    @$('.sync-type').val @model.get 'sync_type'
    @$el

  events:
    'submit form': 'submit'

  hide_loading: =>
    @$('.loading-spinner').hide()

  submit: ($event) =>
    $event.preventDefault()
    $event.stopPropagation()
    @model.set @values()
    @model.save()

  values: =>
    number_of_tracks_to_sync: @$('.number-of-tracks').val()
    sync_type: @$('.sync-type').val()
    auto_sync: @$('.auto-sync').prop('checked')
