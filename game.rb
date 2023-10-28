# Game クラスの役割：
# ゲームの司会進行 (参加者への指示、勝敗の判定、ゲームオーバーの判定)
class Game
  def initialize(player, computer_player1, computer_player2, dealer, card)
    @player = player
    @computer_player1 = computer_player1
    @computer_player2 = computer_player2
    @dealer = dealer
    @card = card
  end

  def blackjack_game
    start
    puts '--------'
    player_continue
    return if @player.is_bust

    dealer_continue
    return if @dealer.is_bust

    puts '--------'
    fight
    show_result
  end

  private

  def start
    puts 'ブラックジャックを開始します。'
    @player.draw_card(@card)
    @player.draw_card(@card)
    @computer_player1.draw_card(@card)
    @computer_player1.draw_card(@card)
    @computer_player2.draw_card(@card)
    @computer_player2.draw_card(@card)
    @dealer.draw_card(@card)
    @dealer.draw_card(@card)
  end

  def player_continue
    loop do
      @player.show_current_sum
      human_player_continue
      # プレイヤーがバストしたら、プレイヤーの負けでゲーム終了
      return if @player.is_bust
      # プレイヤーがNならコンピュータはそれ以上引かずに、ディーラーとの勝負へ
      return if @player.is_stand == true

      computer_player_continue(@computer_player1) if !@computer_player1.is_bust && !@computer_player1.is_stand
      computer_player_continue(@computer_player2) if !@computer_player2.is_bust && !@computer_player2.is_stand
      puts '--------'
    end
  end

  def human_player_continue
    response = @player.confirm_continue

    if response == false
      puts "#{@player.name}はスタンドを宣言しました。ディーラーと勝負します。"
      puts '--------'
      @player.is_stand = true
      return
    end

    @player.draw_card(@card)

    # TARGET_NUMBER を超えた場合
    return unless @player.hand.sum > Participant::TARGET_NUMBER

    # 手札に A がある場合の判定
    @player.is_bust = @player.judge_a
  end

  def computer_player_continue(computer_player)
    # コンピュータは、合計値が 17 を超えたらスタンドを宣言する
    if computer_player.hand.sum > 17
      puts "#{computer_player.name}はスタンドを宣言しました。"
      computer_player.is_stand = true
      return
    end

    computer_player.draw_card(@card)

    # TARGET_NUMBER を超えていなければここで return
    return unless computer_player.hand.sum > Participant::TARGET_NUMBER

    # 手札に A がある場合の判定
    computer_player.is_bust = computer_player.judge_a
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
      @dealer.is_bust = @dealer.judge_a if @dealer.hand.sum > Participant::TARGET_NUMBER
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
