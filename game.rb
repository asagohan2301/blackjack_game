require 'debug'
# binding.break

class Game
  def initialize(player, dealer, card)
    @player = player
    @dealer = dealer
    @card = card
    @target_number = 21
    @is_game_over = false
  end

  def blackjack_game
    start
    continue
    show_result unless @is_game_over
    p @card.all_cards # 検証用
  end

  private

  def start
    puts 'ブラックジャックを開始します。'
    # プレイヤーがカードを引く
    @player.draw_card(@card)
    @player.draw_card(@card)
    # ディーラーがカードを引く
    @dealer.draw_card(@card)
    @dealer.draw_card(@card)
  end

  def continue
    response = @player.confirm_continue

    if response == true
      loop do
        @player.draw_card(@card)
        # maximum を超えたら即プログラム終了
        if @player.current_sum > @player.maximum
          @is_game_over = @player.game_over
          return
        end
        # maximum を超えていなければ、再度プレイヤーにカードを引くかどうか確認
        response = @player.confirm_continue
        # プレイヤーが N を入力したらこのループを抜ける
        break if response == false
      end
    end

    @dealer.show_second_card
    @dealer.show_current_sum
    @dealer.draw_card(@card) while @dealer.current_sum < @dealer.minimum
    @player.show_total
    @dealer.show_total
  end

  def show_result
    player_score = (@player.current_sum - @target_number).abs
    dealer_score = (@dealer.current_sum - @target_number).abs
    if player_score < dealer_score
      puts 'あなたの勝ちです！'
    elsif player_score == dealer_score
      puts '引き分けです。'
    else
      puts 'あなたの負けです。'
    end
    puts 'ブラックジャックを終了します。'
  end
end
