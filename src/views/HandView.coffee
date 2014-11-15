class window.HandView extends Backbone.View
  className: 'hand'

  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> (<span class="score"></span>)</h2>'

  initialize: ->
    @collection.on 'add remove change', => @render()
    @render()
    # bust logic goes here
    @collection.on 'BlackJack', =>
      alert('BlackJack!')

    @collection.on 'add', =>
      if @collection.minScore() > 21
        alert('busted')
      # if @collection.hasBlackJack()
      #   @collection.blackJack()


    # if @collection.hasBlackJack()
    #   console.log 'has BlackJack'
    #   @collection.stand()
    #   @render()
        # start a new game
    # blackjack logic goes here
    # @collection.blackJack()

  render: ->
    # else
    #   bestscore = @collection.scores()[1]
    #   if bestscore > 21
    #     bestscore = @collection.scores()[0]
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    @$('.score').text @collection.bestscore()

