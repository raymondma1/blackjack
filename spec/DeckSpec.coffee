assert = chai.assert

describe 'deck', ->
  deck = null
  hand = null

  beforeEach ->
    deck = new Deck()
    hand = deck.dealPlayer()

  describe 'hit', ->
    it 'should give the last card from the deck', ->
      # console.log hand
      assert.strictEqual deck.length, 50
      # console.log deck.last(), hand.hit()
      assert.strictEqual deck.last(), hand.hit().last()
      assert.strictEqual deck.length, 49
    it 'should decrease deck by one everytime you hit', ->
      assert.strictEqual deck.length, 50
      hand.hit()
      assert.strictEqual deck.length, 49
      assert.strictEqual deck.length, 49
      hand.hit()
      assert.strictEqual deck.length, 48

