class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('dealerHand').stand()

  checkBlackJack: ->
    if @model.get('playerHand').hasBlackJack() or @model.get('dealerHand').hasBlackJack()
      @model.get('playerHand').blackJack()

  initialize: ->
    @render()
    window.setTimeout(this.checkBlackJack.bind(this),100)
    @model.get('playerHand').on 'BlackJack busted', =>
      @model.set 'playerHand', @model.get('deck').dealPlayer()
      @model.set 'dealerHand', @model.get('deck').dealDealer()
      @initialize()
    @model.get('dealerHand').on 'BlackJack busted', =>
      @model.set 'playerHand', @model.get('deck').dealPlayer()
      @model.set 'dealerHand', @model.get('deck').dealDealer()
      @initialize()
    @model.get('dealerHand').on 'ended', =>
      pHand = @model.get('playerHand').bestScore()
      dHand = @model.get('dealerHand').bestScore()
      console.log('player: ', pHand, 'dealer: ', dHand)
      if pHand > dHand
        alert('you win!')
      else if dHand > pHand
        alert('dealer wins!')
      else
        alert('push')
      @restart()

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

  restart: ->
    @model.set 'playerHand', @model.get('deck').dealPlayer()
    @model.set 'dealerHand', @model.get('deck').dealDealer()
    @initialize()
