require './game'
require './participant'
require './card'

player = Player.new('あなた')
computer_player1 = Player.new('コンピュータ1')
dealer = Dealer.new('ディーラー')
card = Card.new
game = Game.new(player, computer_player1, dealer, card)
game.blackjack_game
