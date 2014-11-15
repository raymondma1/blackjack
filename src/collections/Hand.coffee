class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop())

  stand: ->
    # reveal the dealer's hidden card
    @at(0).flip()
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

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]


