# Game クラス：ゲームの流れを作る (条件分岐) / ゲーム進行や勝敗に関する表示は Game クラスが行う
class Game
  def initialize(player, computer_player1, computer_player2, dealer, card)
    @player = player
    @computer_player1 = computer_player1
    @computer_player2 = computer_player2
    @dealer = dealer
    @card = card
  end

  def blackjack_game
    puts 'ブラックジャックを開始します。'
    bet
    draw
    player_continue
    return if @player.is_bust

    puts 'プレイヤー全員がカードを引き終えました。'

    dealer_continue
    return if @dealer.is_bust

    puts '全員がカードを引き終えました。勝負に進みます。'

    fight
    bet_result(result)
    over
  end

  private

  def bet
    @player.show_balance
    @player.confirm_chip
    puts
  end

  def draw
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
      puts
      @player.show_current_sum unless @player.is_stand
      human_player_continue
      return if @player.is_bust

      computer_player_continue(@computer_player1)
      computer_player_continue(@computer_player2)

      all_players_done = [@player, @computer_player1, @computer_player2].all? { |player| player.is_bust || player.is_stand }
      return if all_players_done
    end
  end

  def human_player_continue
    human_player_confirm
    human_player_draw
  end

  def human_player_confirm
    return if @player.is_bust || @player.is_stand

    # 得点が TARGET_NUMBER なら確認せずに進む
    if @player.hand.sum == Participant::TARGET_NUMBER
      puts '最強の得点です。'
      @player.stand
      return
    end

    # ダブルダウンの確認は1回だけ
    @player.confirm_double_down if @player.is_double_down == 'undecided'
    return if @player.is_double_down == 'Y'

    response = @player.confirm_continue
    @player.stand if response == false
  end

  def human_player_draw
    return if @player.is_bust || @player.is_stand

    @player.draw_card(@card)
    @player.stand if @player.is_double_down == 'Y'

    # TARGET_NUMBER を超えなければここで return
    return unless @player.hand.sum > Participant::TARGET_NUMBER

    # TARGET_NUMBER を超えた場合、手札に A があるかどうか判定
    if @player.hand.include?(11)
      @player.set_ace
    else
      @player.bust
      bet_result('lose')
      over
    end
  end

  def computer_player_continue(computer_player)
    return if computer_player.is_bust || computer_player.is_stand

    # コンピュータは、合計値が 17 を超えたらスタンドを宣言する
    if computer_player.hand.sum > 17
      computer_player.stand
      return
    end

    computer_player.draw_card(@card)
    return unless computer_player.hand.sum > Participant::TARGET_NUMBER

    computer_player.hand.include?(11) ? computer_player.set_ace : computer_player.bust
  end

  def dealer_continue
    puts
    @dealer.show_second_card
    @dealer.show_current_sum

    # ディーラーの最初の二枚が A と A の場合
    if @dealer.hand.sum == 22
      index = @dealer.hand.index(11)
      @dealer.hand[index] = 1
    end

    return if @dealer.hand.sum >= @dealer.minimum

    puts 'ディーラーは得点が17以上になるまでカードを引きます。'
    while @dealer.hand.sum < @dealer.minimum
      @dealer.draw_card(@card)
      if @dealer.hand.sum > Participant::TARGET_NUMBER
        if @dealer.hand.include?(11)
          @dealer.set_ace
        else
          @dealer.bust
          puts '残ったプレイヤーたちの勝ちです。'
          bet_result('win')
          over
        end
      end
    end
  end

  def fight
    puts
    @player.show_total
    @dealer.show_total
  end

  def result
    if @player.hand.sum > @dealer.hand.sum
      puts "#{@player.name}の勝ちです！"
      'win'
    elsif @player.hand.sum == @dealer.hand.sum
      puts '引き分けです。'
      'draw'
    else
      puts "#{@player.name}の負けです。"
      'lose'
    end
  end

  def bet_result(result)
    puts
    @player.settle_bet(result)
    @player.show_balance
  end

  def over
    puts 'ブラックジャックを終了します。'
  end
end
