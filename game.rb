# Game クラスの役割：
# ゲームの司会進行 (参加者への指示、勝敗の判定、ゲームオーバーの判定)
class Game
  def initialize(player, computer_player1, dealer, card)
    @player = player
    @computer_player1 = computer_player1
    @dealer = dealer
    @card = card
    @player_is_game_over = false
    @computer_player1_is_game_over = false
    @dealer_is_game_over = false
    @player_stand = false
    @computer_player1_stand = false
  end

  def blackjack_game
    start

    puts '--------'

    player_continue
    return if @player_is_game_over

    dealer_continue
    return if @dealer_is_game_over

    puts '--------'

    fight
    show_result

    # 検証用
    p @card.show_deck
    p @player.hand
    p @computer_player1.hand
    p @dealer.hand
  end

  private

  def start
    puts 'ブラックジャックを開始します。'
    @player.draw_card(@card)
    @player.draw_card(@card)
    @computer_player1.draw_card(@card)
    @computer_player1.draw_card(@card)
    @dealer.draw_card(@card)
    @dealer.draw_card(@card)
  end

  def player_continue
    loop do
      @player.show_current_sum
      human_player_continue

      return if @player_is_game_over # プレイヤーがバストしたら、プレイヤーの負けでゲーム終了

      return if @player_stand == true # プレイヤーがNならコンピュータはそれ以上引かずに、ディーラーとの勝負へ

      computer_player_continue if !@computer_player1_is_game_over && !@computer_player1_stand
      puts '--------'
    end
  end

  def human_player_continue
    response = @player.confirm_continue

    if response == false
      puts "#{@player.name}はスタンドを宣言しました。ディーラーと勝負します。"
      puts '--------'
      @player_stand = true
      return
    end

    @player.draw_card(@card)

    # TARGET_NUMBER を超えた場合
    return unless @player.hand.sum > Participant::TARGET_NUMBER

    # 手札に A がある場合の判定
    @player_is_game_over = @player.judge_a
  end

  def computer_player_continue
    # コンピュータは、合計値が 17 を超えたらスタンドを宣言する
    if @computer_player1.hand.sum > 17
      puts "#{@computer_player1.name}はスタンドを宣言しました。"
      @computer_player1_stand = true
      return
    end

    @computer_player1.draw_card(@card)

    # TARGET_NUMBER を超えた場合
    return unless @computer_player1.hand.sum > Participant::TARGET_NUMBER

    # 手札に A がある場合の判定
    @computer_player1_is_game_over = @computer_player1.judge_a
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
      @dealer_is_game_over = @dealer.judge_a if @dealer.hand.sum > Participant::TARGET_NUMBER
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
