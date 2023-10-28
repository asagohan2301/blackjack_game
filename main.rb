require './game'
require './participant'
require './card'

player = HumanPlayer.new('あなた')
computer_player1 = ComputerPlayer.new('コンピュータ1')
computer_player2 = ComputerPlayer.new('コンピュータ2')
dealer = Dealer.new('ディーラー')
card = Card.new
game = Game.new(player, computer_player1, computer_player2, dealer, card)
game.blackjack_game
