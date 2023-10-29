require './game'
require './participant'
require './card'

player = Player.new('あなた')
computer_player1 = Player.new('コンピュータ1')
computer_player2 = Player.new('コンピュータ2')
dealer = Dealer.new('ディーラー')
card = Card.new
game = Game.new(player, computer_player1, computer_player2, dealer, card)
game.blackjack_game
