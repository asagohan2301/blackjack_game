require "debug"

# Game クラスの役割：
# ゲームの司会進行 (参加者への指示、勝敗の判定、ゲームオーバーの判定)
class Game
  def initialize(player, dealer, card)
    @player = player
    @dealer = dealer
    @card = card
    @target_number = 21
    @player_is_game_over = false
    @dealer_is_game_over = false
  end

  def blackjack_game
    start
    continue
    return if @player_is_game_over

    fight
    return if @dealer_is_game_over

    # binding.break

    show_result
    # 検証用
    puts @card.all_cards
  end

  private

  def start
    puts 'ブラックジャックを開始します。'
    @player.draw_card(@card)
    @player.draw_card(@card)
    @dealer.draw_card(@card)
    @dealer.draw_card(@card)
  end

  def continue
    @player.show_current_sum
    response = @player.confirm_continue
    return if response == false

    loop do
      @player.draw_card(@card)
      # TARGET_NUMBER を超えたら即プログラム終了
      if @player.current_sum > Participant::TARGET_NUMBER
        puts "カードの合計値が#{Participant::TARGET_NUMBER}を超えました。あなたの負けです。"
        puts 'ブラックジャックを終了します。'
        @player_is_game_over = true
        return
      end
      # TARGET_NUMBER を超えていなければ、再度プレイヤーにカードを引くかどうか確認
      @player.show_current_sum
      response = @player.confirm_continue
      # プレイヤーが N を入力したらこのループを抜ける
      break if response == false
    end
  end

  def dealer_continue
  end

  def fight
    @dealer.show_second_card
    @dealer.show_current_sum
    # ディーラーにもゲームオーバーを作る
    @dealer.draw_card(@card) while @dealer.current_sum < @dealer.minimum
    # TARGET_NUMBER を超えたら即プログラム終了
    if @dealer.current_sum > Participant::TARGET_NUMBER
      puts "ディーラーのカードの合計値が#{Participant::TARGET_NUMBER}を超えました。あなたの勝ちです。"
      puts 'ブラックジャックを終了します。'
      @dealer_is_game_over = true
      return
    end
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
