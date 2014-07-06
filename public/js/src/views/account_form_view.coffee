class window.AccountFormView extends Backbone.View
  template: JST['account_form']

  initialize: =>
    @listenTo @model, 'change', @render
    @listenTo @model, 'sync error', @hide_loading
    @listenTo @model, 'request', @show_loading

  context: =>
    model: @model.toJSON()

  render: =>
    @$el.html @template @context()
    @$('.sync-type').val @model.get 'sync_type'
    @$el

  events:
    'submit form': 'submit'
    'click button.sync': 'initiate_sync'

  hide_loading: =>
    @$('.loading-spinner').hide()

  show_loading: =>
    @$('.loading-spinner').show()

  submit: ($event) =>
    $event.preventDefault()
    $event.stopPropagation()
    @model.set @values()
    @model.save()

  initiate_sync: ($event) =>
    $event.preventDefault()
    $event.stopPropagation()
    @model.set @values()
    @model.save sync_now: true

  values: =>
    number_of_tracks_to_sync: @$('.number-of-tracks').val()
    sync_type: @$('.sync-type').val()
    auto_sync: @$('.auto-sync').prop('checked')
