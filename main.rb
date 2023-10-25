require './game'
require './participant'
require './card'

player = Player.new
dealer = Dealer.new
card = Card.new
game = Game.new(player, dealer, card)
game.blackjack_game
