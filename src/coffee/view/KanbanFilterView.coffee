exports.KanbanFilterView = class KanbanFilterView extends Backbone.View

  className: 'kanban-filter-view'

  filters: null
  $filters: []

  $team: null
  $key: null

  ticketCollection: null

  events:
    'click .kanban-button': '_onFilterClick'
    'click .kanban-link': '_onEditFilterClicked'

  initialize: (options) ->
    {@ticketCollection, @filters} = options

    @listenTo @ticketCollection, 'sync', @_stopSpinner
    @render()

  render: ->
    @$el.append editFilterTemplate()

    for filter in @filters
      @$el.append filterTemplate(filter)

    @$el.append filterButtonTemplate()

    @_loadFromLocalStorage()

  _onFilterClick: ->

    params = {}
    for filter in @filters
      params[filter.name] = @$(".#{filter.name}-input").val()

    @$('.fa-spinner').removeClass 'hidden'

    #fetch from the server om click
    @ticketCollection.fetch(data: params)

    @_saveToLocalStorage(params)

  _saveToLocalStorage: (params) ->
    for key of params
      localStorage.setItem(key, params[key])
    return @

  _loadFromLocalStorage: ->
    for filter in @filters
      val = localStorage.getItem(filter.name)
      @$(".#{filter.name}-input").val(val)

    return @

  _onEditFilterClicked: ->
    @$('.kanban-label').show()
    @$('.kanban-input').show()
    @$('.kanban-link').hide()

  _stopSpinner: ->
    @$('.fa-spinner').addClass 'hidden'

    @$('.kanban-label').hide()
    @$('.kanban-input').hide()
    @$('.kanban-link').show()

editFilterTemplate = ->
  """
  <span class="kanban-link" style="display: none;">edit filter</span>
  """

filterTemplate = (filter) ->
  """
  <span class="kanban-label #{filter.name}-label">#{filter.text}:</span><input placeholder="#{filter.description}" class="kanban-input #{filter.name}-input" type="#{filter.type}"></input>
  """
filterButtonTemplate = ->
  """
  <span class="kanban-button filter-button">Load</span>
  <i class="fa fa-spinner fa-pulse fa-fw hidden"></i>
  """
