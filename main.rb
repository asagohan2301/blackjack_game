require './game'
require './participant'
require './card'

player = Player.new('あなた')
dealer = Dealer.new('ディーラー')
card = Card.new
game = Game.new(player, dealer, card)
game.blackjack_game
