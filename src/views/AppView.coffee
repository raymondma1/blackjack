class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <button class="reset-button">Reset</button>

    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
    <div class="deckCards"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('dealerHand').stand()
    'click .reset-button': -> @restart()

  checkBlackJack: ->
    if @model.get('playerHand').hasBlackJack() or @model.get('dealerHand').hasBlackJack()
      @model.get('playerHand').blackJack()

  initialize: ->
    @render()
    window.setTimeout(this.checkBlackJack.bind(this),100)
    # @model.get('deck').on 'remove', => @render()
    @model.get('playerHand').on 'BlackJack busted', =>
      @model.get('dealerHand').at(0).flip()
      @$el.find('.hit-button').remove()
      @$el.find('.stand-button').remove()
    @model.get('dealerHand').on 'BlackJack busted', =>
      @$el.find('.hit-button').remove()
      @$el.find('.stand-button').remove()
    @model.get('dealerHand').on 'ended', =>
      pHand = @model.get('playerHand').bestScore()
      dHand = @model.get('dealerHand').bestScore()
      if pHand > dHand
        alert('you win!')
      else if dHand > pHand
        alert('dealer wins!')
      else
        alert('push')
      @$el.find('.hit-button').remove()
      @$el.find('.stand-button').remove()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    @$('.deckCards').html new DeckView(collection: @model.get 'deck').el

  restart: ->
    if @model.get('deck').length < 36
     @model.set 'deck', deck = new Deck()
    @model.set 'playerHand', @model.get('deck').dealPlayer()
    @model.set 'dealerHand', @model.get('deck').dealDealer()
    @initialize()
