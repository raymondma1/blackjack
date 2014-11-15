class window.CardView extends Backbone.View
  className: 'card'

  # template: _.template '<%= rankName %> of <%= suitName %>'
  template: _.template '<img src="./img/cards/<%= rank %>-<%= suitName %>.png">'
  coveredTemplate: _.template '<img src="./img/card-back.png">'
  initialize: -> @render()

  render: ->
    @$el.children().detach()
    @$el.html @template @model.attributes
    # @$el.addClass 'covered' unless @model.get 'revealed'
    @$el.html @coveredTemplate @model.attributes unless @model.get 'revealed'
    # @$el.addClass 'covered' unless @model.get 'revealed'
