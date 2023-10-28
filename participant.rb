# Participant クラスの役割：
# Game クラスからの指示で実際に動作を行う。現在の得点を持つ。プレイヤーとディーラーそれぞれに割り振れる役割はこちらに任せる。
class Participant
  attr_reader :current_sum, :border, :minimum

  # 追加
  TARGET_NUMBER = 21

  def initialize(name)
    # @border = border
    @name = name
    @current_sum = 0
  end

  def draw_card(card)
    card.shuffle # カードのインスタンス変数に値が入る
    draw_card_message(card.value, card.suit_ja)
    @current_sum += card.number
  end

  def draw_card_message(value, suit_ja)
  end

  def show_current_sum
    puts "#{@name}の現在の得点は#{@current_sum}です。"
  end

  def show_total
    puts "#{@name}の最終の得点は#{@current_sum}です。"
  end
end

class Player < Participant
  def initialize
    super('あなた')
  end

  def draw_card_message(value, suit_ja)
    puts "#{@name}の引いたカードは#{suit_ja}の#{value}です。"
  end

  def confirm_continue
    puts 'カードを引きますか？（Y/N）'
    y_or_n = gets.chomp
    if y_or_n.chomp == 'Y'
      true
    elsif y_or_n.chomp == 'N'
      false
    end
  end
end

class Dealer < Participant
  def initialize
    super('ディーラー')
    @second_card_suit
    @second_card_value
    @draw_card_count = 0
    @minimum = 17
  end

  def draw_card_message(value, suit_ja)
    @draw_card_count += 1
    if @draw_card_count == 2
      puts "#{@name}の引いた2枚目のカードはわかりません。"
      @second_card_suit = suit_ja
      @second_card_value = value
    else
      puts "#{@name}の引いたカードは#{suit_ja}の#{value}です。"
    end
  end

  def show_second_card
    puts "#{@name}の引いた2枚目のカードは#{@second_card_suit}の#{@second_card_value}でした。"
  end
end
