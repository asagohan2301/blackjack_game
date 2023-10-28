# Game クラスの役割：
# ゲームの司会進行 (参加者への指示、勝敗の判定、ゲームオーバーの判定)
class Game
  def initialize(player, dealer, card)
    @player = player
    @dealer = dealer
    @card = card
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
    show_result

    # 検証用
    p @card.all_cards
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
      if @player.hand.sum > Participant::TARGET_NUMBER
        # 手札に A がある場合
        if @player.hand.include?(11)
          puts "#{@player.name}のカードの合計値が#{Participant::TARGET_NUMBER}を超えました。手札にあるAを1として計算します。"
          # 手札の 11 を 1 に書き換える
          index = @player.hand.index(11)
          @player.hand[index] = 1
        else
          puts "カードの合計値が#{Participant::TARGET_NUMBER}を超えました。#{@player.name}の負けです。"
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

  def dealer_continue
    @dealer.show_second_card
    @dealer.show_current_sum

    # ディーラーの最初の二枚が A と A の場合
    if @dealer.hand.sum == 22
      index = @dealer.hand.index(11)
      @dealer.hand[index] = 1
    end

    return if @dealer.hand.sum >= @dealer.minimum

    while @dealer.hand.sum < @dealer.minimum
      @dealer.draw_card(@card)
      # TARGET_NUMBER を超えたら即プログラム終了
      if @dealer.hand.sum > Participant::TARGET_NUMBER
        if @dealer.hand.include?(11)
          puts "#{@dealer.name}のカードの合計値が#{Participant::TARGET_NUMBER}を超えました。手札にあるAを1として計算します。"
          # 手札の 11 を 1 に書き換える
          index = @dealer.hand.index(11)
          @dealer.hand[index] = 1
        else
          puts "#{@dealer.name}のカードの合計値が#{Participant::TARGET_NUMBER}を超えました。#{@player.name}の勝ちです。"
          puts 'ブラックジャックを終了します。'
          @dealer_is_game_over = true
        end
      end
    end
  end

  def fight
    @player.show_total
    @dealer.show_total
  end

  def show_result
    if @player.hand.sum > @dealer.hand.sum
      puts "#{@player.name}の勝ちです！"
    elsif @player.hand.sum == @dealer.hand.sum
      puts '引き分けです。'
    else
      puts "#{@player.name}の負けです。"
    end
    puts 'ブラックジャックを終了します。'
  end
end
