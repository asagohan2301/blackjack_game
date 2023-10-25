class Player
  attr_accessor :current_sum, :maximum

  def initialize
    @current_sum = 0
    @maximum = 21
  end

  def draw_card(card)
    suit = card.select_suit
    number = card.all_cards[suit].delete_at(rand(card.all_cards[suit].length))
    number = 10 if %w[J Q K].include?(number)
    puts "あなたの引いたカードは#{card.suit_to_j(suit)}の#{number}です。"
    @current_sum += number
  end

  def game_over
    puts "カードの合計値が#{@maximum}を超えました。あなたの負けです。"
    puts 'ブラックジャックを終了します。'
    # 追加
    true
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

class Dealer
  attr_accessor :current_sum, :minimum

  def initialize
    @current_sum = 0
    @minimum = 17
    @second_card_suit
    @second_card_number
    @draw_card_count = 0
  end

  def draw_card(card)
    @draw_card_count += 1
    suit = card.select_suit
    number = card.all_cards[suit].delete_at(rand(card.all_cards[suit].length))
    number = 10 if %w[J Q K].include?(number)
    if @draw_card_count == 2
      puts 'ディーラーの引いた2枚目のカードはわかりません。'
      @second_card_suit = card.suit_to_j(suit)
      @second_card_number = number
    else
      puts "ディーラーの引いたカードは#{card.suit_to_j(suit)}の#{number}です。"
    end
    # 合計値を足す
    @current_sum += number
  end

  def show_second_card
    puts "ディーラーの引いた2枚目のカードは#{@second_card_suit}の#{@second_card_number}でした。"
  end

  def show_current_sum
    puts "ディーラーの現在の得点は#{@current_sum}です。"
  end

  def show_total
    puts "ディーラーの得点は#{@current_sum}です。"
  end
end