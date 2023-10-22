require 'debug'
# binding.break

target_number = 21

cards = {
  spade: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
  heart: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
  diamond: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
  club: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']
}

# トランプの柄をランダムに選ぶ関数
def select_suit
  case rand(4)
  when 0 then :spade
  when 1 then :heart
  when 2 then :diamond
  when 3 then :club
  end
end

# トランプの柄を日本語で返す関数
def suit_to_j(suit)
  {
    spade: 'スペード',
    heart: 'ハート',
    diamond: 'ダイヤ',
    club: 'クラブ'
  }[suit]
end

# プレイヤークラス
class Player
  attr_accessor :current_sum, :maximum

  def initialize(maximum)
    @current_sum = 0
    @maximum = maximum
  end

  def draw_card(cards)
    suit = select_suit
    number = cards[suit].delete_at(rand(cards[suit].length))
    number = 10 if %w[J Q K].include?(number)
    puts "あなたの引いたカードは#{suit_to_j(suit)}の#{number}です。"
    @current_sum += number
  end

  def game_over
    puts "カードの合計値が#{@maximum}を超えました。あなたの負けです。"
    puts 'ブラックジャックを終了します。'
  end

  def confirm_continue
    puts "あなたの現在の得点は#{@current_sum}です。カードを引きますか？（Y/N）"
    y_or_n = gets.chomp
    if y_or_n.chomp == 'Y'
      true
    elsif y_or_n.chomp == 'N'
      false
    end
  end

  def show_total
    puts "あなたの得点は#{@current_sum}です。"
  end
end

# ディーラークラス
class Dealer
  attr_accessor :current_sum, :minimum

  def initialize(minimum)
    @current_sum = 0
    @minimum = minimum
    @second_card_suit
    @second_card_number
    @draw_card_count = 0
  end

  def draw_card(cards)
    @draw_card_count += 1
    suit = select_suit
    number = cards[suit].delete_at(rand(cards[suit].length))
    number = 10 if %w[J Q K].include?(number)
    if @draw_card_count == 2
      puts 'ディーラーの引いた2枚目のカードはわかりません。'
      @second_card_suit = suit
      @second_card_number = number
    else
      puts "ディーラーの引いたカードは#{suit_to_j(suit)}の#{number}です。"
    end
    # 合計値を足す
    @current_sum += number
  end

  def show_second_card
    puts "ディーラーの引いた2枚目のカードは#{suit_to_j(@second_card_suit)}の#{@second_card_number}でした。"
  end

  def show_current_sum
    puts "ディーラーの現在の得点は#{@current_sum}です。"
  end

  def show_total
    puts "ディーラーの得点は#{@current_sum}です。"
  end
end

# -------- ゲームの流れ --------

# ---- はじめに必ず行う手順 ----

puts 'ブラックジャックを開始します。'

# インスタンス生成
player = Player.new(21) # maximum を渡す
dealer = Dealer.new(17) # minimum を渡す

# プレイヤーがカードを引く
player.draw_card(cards)
player.draw_card(cards)

# ディーラーがカードを引く
dealer.draw_card(cards)
dealer.draw_card(cards)

# ---- プレイヤーに確認してカードを引き続ける ----

response = player.confirm_continue

if response == true
  loop do
    player.draw_card(cards)
    # maximum を超えたらプログラム終了
    if player.current_sum > player.maximum
      player.game_over
      return
    end
    response = player.confirm_continue
    break if response == false
  end
end

# ---- プレイヤーがカードを引き終わってから ----

if response == false
  dealer.show_second_card
  dealer.show_current_sum
  dealer.draw_card(cards) while dealer.current_sum < dealer.minimum
  player.show_total
  dealer.show_total
end

# ---- 結果発表 ----

player_score = (player.current_sum - target_number).abs
dealer_score = (dealer.current_sum - target_number).abs

if player_score < dealer_score
  puts 'あなたの勝ちです！'
elsif player_score == dealer_score
  puts '引き分けです。'
else
  puts 'あなたの負けです。'
end

puts 'ブラックジャックを終了します。'
