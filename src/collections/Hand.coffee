class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())

  stand: ->
    # console.log @isDealer
    # reveal the dealer's hidden card
    @at(0).flip() #if @isDealer
    # console.log @scores, @minScore()
    # while dealer's scores are all < 17 and minScore() < 22
    # @hit() until @minScore() > 22 #or (@scores[0] > 17 or @scores[1] > 17)# contains a value greater than 17
    @hit() while (Math.max @scores()[0], @scores()[1]) < 17

    if ((Math.max @scores()[0], @scores()[1]) > 21)
      @hit() until @minScore() > 16
      # console.log 'before: ',@minScore(), @scores()
      # # console.log @scores, @minScore()
      # @hit()
      # console.log 'after: ',@minScore(), @scores()

      # dealer hits
    #compare scores and note the winner.

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
    alert('triggering blackjack event')
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

  bestscore: ->
    if @hasAce() and @allRevealed()
      bestscore = @scores()
    else if @allRevealed()
      bestscore = @scores()[1]
      if bestscore > 21
        bestscore = @scores()[0]
    else
      bestscore = @minScore()

    if @hasBlackJack()
      bestscore = 'Blackjack!'
      # @blackJack()
    return bestscore

