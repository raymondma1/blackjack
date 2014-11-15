class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())

  stand: ->
    # reveal the dealer's hidden card
    @at(0).flip() #if @isDealer
    @hit() while (Math.max @scores()[0], @scores()[1]) < 17

    if ((Math.max @scores()[0], @scores()[1]) > 21)
      @hit() until @minScore() > 16
    #compare scores and note the winner.
    if not @isBusted()
      @ended()

  ended: ->
    #fire ended trigger
    @trigger 'ended', @



  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  hasFace: -> @reduce (memo, card) ->
    memo or _([0, 10, 11, 12]).contains(card.get('value'))# is 0 or 10 or 11 or 12
  , 0

  isBusted: -> return @minScore() > 21

  busted: ->
    @trigger 'busted',@

  hasBlackJack: ->
    return @length == 2 and @hasFace() and @hasAce()#@scores()[1] == 21
      #bestscore = 'Blackjack!'

  blackJack: ->
    @trigger 'BlackJack',@

  allRevealed: -> @every (card) -> card.get 'revealed'

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]

  scoreToDisplay: ->
    if @hasAce() and @allRevealed()
      scoreToDisplay = @scores()
    else if @allRevealed()
      scoreToDisplay = @scores()[1]
      if scoreToDisplay > 21
        scoreToDisplay = @scores()[0]
    else
      scoreToDisplay = @minScore()

    if @hasBlackJack()
      scoreToDisplay = 'Blackjack!'
      # @blackJack()
    return scoreToDisplay

  bestScore: ->
    bestScore = @scores()[1]
    if bestScore > 21
      bestScore = @scores()[0]
    return bestScore

