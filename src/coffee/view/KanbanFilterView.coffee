exports.KanbanFilterView = class KanbanFilterView extends Backbone.View

  className: 'kanban-filter-view'

  ticketCollection: null
  viewState: null

  events:
    'click .kanban-button': '_onFilterClick'
    'click .kanban-link': '_showFilters'

  initialize: (options) ->
    {@ticketCollection, @viewState} = options

    @listenTo @ticketCollection, 'sync', @_stopSpinner
    @render()

  render: ->
    @$el.append editFilterTemplate()

    for filter in @collection
      @$el.append filterTemplate(filter)

    @$el.append filterButtonTemplate()

    @_loadFromLocalStorage()

  _onFilterClick: ->

    params = {}
    for filter in @collection
      params[filter.name] = @$(".#{filter.name}-input").val()

    @$('.fa-spinner').removeClass 'hidden'

    #fetch from the server om click
    @ticketCollection.fetch(data: params)

    @_saveToLocalStorage(params)

  _saveToLocalStorage: (params) ->
    for key of params
      localStorage.setItem(key, params[key])
      @viewState.set(key, params[key])
    return @

  _loadFromLocalStorage: ->
    hideFilters = false
    for filter in @collection
      val = localStorage.getItem(filter.name)
      @viewState.set(filter.name, val)

      @$(".#{filter.name}-input").val(val)
      if val
        hideFilters = true

    if(hideFilters)
      @_hideFilters()

    return @

  _showFilters: ->
    @$('.kanban-label').show()
    @$('.kanban-input').show()
    @$('.kanban-link').hide()

  _hideFilters: ->
    #TODO use multiple selectors
    @$('.kanban-label').hide()
    @$('.kanban-input').hide()
    @$('.kanban-link').show()

  _stopSpinner: ->
    @$('.fa-spinner').addClass 'hidden'
    @_hideFilters()


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
  <span class="kanban-button filter-button"><i class="fa fa-refresh" aria-hidden="true"></i>Refresh</span>
  <i class="fa fa-spinner fa-pulse fa-fw hidden"></i>
  """
