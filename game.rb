# Game クラスの役割：
# ゲームの司会進行 (参加者への指示、勝敗の判定、ゲームオーバーの判定)
class Game
  def initialize(player, computer_player1, dealer, card)
    @player = player
    @computer_player1 = computer_player1
    @dealer = dealer
    @card = card
    @player_is_game_over = false
    @dealer_is_game_over = false
    # 追加
    @computer_player1_is_game_over = false
    @player_response = ''
  end

  def blackjack_game
    start
    puts '--------'
    player_continue
    return if @player_is_game_over

    dealer_continue
    return if @dealer_is_game_over

    fight
    puts '--------'
    show_result

    # 検証用
    p @card.all_cards
    p @player.hand
    p @computer_player1.hand
    p @dealer.hand
  end

  private

  def start
    puts 'ブラックジャックを開始します。'
    2.times do
      @player.draw_card(@card)
      @computer_player1.draw_card(@card)
      @dealer.draw_card(@card)
    end
  end

  def player_continue
    loop do
      @player.show_current_sum
      @computer_player1.show_current_sum unless @computer_player1_is_game_over

      human_player_continue

      return if @player_is_game_over # あなたがゲームおーばならもうおわり

      return if @player_response == 'N' # あなたがNなら他のプレイヤーはもう引かずにおわりいったん

      computer_player_continue

      puts '--------'
    end
  end

  def human_player_continue
    response = @player.confirm_continue

    if response == false
      puts "Nが選ばれました。今の手札でディーラーと勝負します。"
      @player_response = 'N'
      return
    end

    @player.draw_card(@card)
    if @player.hand.sum > Participant::TARGET_NUMBER
      # 手札に A がある場合
      if @player.hand.include?(11)
        puts "#{@player.name}のカードの合計値が#{Participant::TARGET_NUMBER}を超えました。手札にあるAを1として計算します。"
        # 手札の 11 を 1 に書き換える
        index = @player.hand.index(11)
        @player.hand[index] = 1
        @player.show_current_sum # 追加
      else
        puts "カードの合計値が#{Participant::TARGET_NUMBER}を超えました。#{@player.name}の負けです。"
        puts 'ブラックジャックを終了します。'
        @player_is_game_over = true
        return
      end
    end
  end

  def computer_player_continue
    return if @computer_player1_is_game_over # すでにゲームオーバーならこの後の処理はしない

    # unless @computer_player1_is_game_over
    puts "#{@computer_player1.name}がカードを引きます。"
    @computer_player1.draw_card(@card)
    # 21 を超えたら退場
    if @computer_player1.hand.sum > Participant::TARGET_NUMBER
      puts "#{@computer_player1.name}のカードの合計値が#{Participant::TARGET_NUMBER}を超えました。"
      puts "#{@computer_player1.name}はゲームオーバーです。"
      @computer_player1_is_game_over = true
    end
    # end
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
          puts "#{@dealer.name}のカードの合計値が#{Participant::TARGET_NUMBER}を超えました。プレイヤーたちの勝ちです。"
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
