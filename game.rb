require "debug"

# Game クラスの役割：
# ゲームの司会進行 (参加者への指示、勝敗の判定、ゲームオーバーの判定)
class Game
  def initialize(player, dealer, card)
    @player = player
    @dealer = dealer
    @card = card
    # @target_number = 21
    @player_is_game_over = false
    @dealer_is_game_over = false
  end

  def blackjack_game
    start
    player_continue
    return if @player_is_game_over

    dealer_continue
    return if @dealer_is_game_over

    fight
    # binding.break

    show_result
    # 検証用
    puts @card.all_cards
    p @player.hand
    p @dealer.hand
  end

  private

  def start
    puts 'ブラックジャックを開始します。'
    @player.draw_card(@card)
    @player.draw_card(@card)
    @dealer.draw_card(@card)
    @dealer.draw_card(@card)
  end

  def player_continue
    @player.show_current_sum
    response = @player.confirm_continue
    return if response == false

    loop do
      @player.draw_card(@card)
      # TARGET_NUMBER を超えたら即プログラム終了
      if @player.hand.sum > Participant::TARGET_NUMBER # 変更
        # 追加 もし手札にAがあった時を考える
        # また、引いたカードがAだった時のことも...?いや今引いたカードももう手札に入っているからOKか
        if @player.hand.include?(11)
          puts "プレイヤー、A持ってるよ！！"
          # A を 1 とする
          index = @player.hand.index(11)
          @player.hand[index] = 1 # 11 を 1 に書き換え
          # @player.current_sum = @player.hand.sum
          # それでも21を超えている場合ってあるかな？？ないよね？検証まだ
        else
          puts "カードの合計値が#{Participant::TARGET_NUMBER}を超えました。あなたの負けです。"
          puts 'ブラックジャックを終了します。'
          @player_is_game_over = true
          return
        end
      end
      # TARGET_NUMBER を超えていなければ、再度プレイヤーにカードを引くかどうか確認
      @player.show_current_sum
      response = @player.confirm_continue
      # プレイヤーが N を入力したらこのループを抜ける
      break if response == false
    end
  end

  # ディーラーもloop?
  def dealer_continue
    @dealer.show_second_card
    @dealer.show_current_sum
    # ディーラーにもゲームオーバーを作る
    @dealer.draw_card(@card) while @dealer.hand.sum < @dealer.minimum
    # TARGET_NUMBER を超えたら即プログラム終了
    if @dealer.hand.sum > Participant::TARGET_NUMBER
      # 追加 もし手札にAがあった時を考える
      # また、引いたカードがAだった時のことも...?いや今引いたカードももう手札に入っているからOKか
      if @dealer.hand.include?(11)
        puts "ディーラー、A持ってるよ！！"
        # A を 1 とする
        index = @dealer.hand.index(11)
        @dealer.hand[index] = 1 # 11 を 1 に書き換え
        # @dealer.current_sum = @dealer.hand.sum
        # それでも21を超えている場合ってあるかな？？ないよね？検証まだ
        # で、ここでまだ17未満ならさらにカードを引いていかないと！！！
      else
        puts "ディーラーのカードの合計値が#{Participant::TARGET_NUMBER}を超えました。あなたの勝ちです。"
        puts 'ブラックジャックを終了します。'
        @dealer_is_game_over = true
        return
      end
    end
  end

  def fight
    @player.show_total
    @dealer.show_total
  end

  def show_result
    player_score = (@player.hand.sum - Participant::TARGET_NUMBER).abs
    dealer_score = (@dealer.hand.sum - Participant::TARGET_NUMBER).abs
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
