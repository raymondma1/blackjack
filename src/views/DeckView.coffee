class window.DeckView extends Backbone.View
  className: 'deck'
  #on initialize
  #on card dealsx
  # template: _.template '<img src="./img/cards/<%= rank %>-<%= suitName %'
  initialize: ->
    @collection.on 'remove', => @render()
    @render()

  render: ->
    @$el.children().detach()
    @$el.html 'Cards left in deck: ' + @collection.length
