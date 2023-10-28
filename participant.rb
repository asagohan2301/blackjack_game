# Participant クラスの役割：
# Game クラスからの指示で実際に動作を行う。現在の得点を持つ。現在の手持ちのカードの配列を持つ。共通の細かい処理とか。プレイヤーとディーラーそれぞれに割り振れる役割はこちらに任せる。
class Participant
  TARGET_NUMBER = 21
  attr_reader :name, :minimum, :hand

  def initialize(name)
    @name = name
    @hand = []
  end

  def draw_card(card)
    card.shuffle # カードのインスタンス変数に値が入る
    draw_card_message(card.value, card.suit_ja)
    @hand.push(card.number)
  end

  def draw_card_message(value, suit_ja)
    puts "#{@name}の引いたカードは#{suit_ja}の#{value}です。"
  end

  def judge_a
    if @hand.include?(11)
      # 手札の 11 を 1 に書き換える
      index = @hand.index(11)
      @hand[index] = 1
      puts "#{@name}のカードの合計値が#{TARGET_NUMBER}を超えました。手札にあるAを1として計算します。計算しなおした合計値は#{@hand.sum}です。"
    else
      puts "#{@name}のカードの合計値が#{TARGET_NUMBER}を超えました。#{@name}はバストしました。"
      judge_a_message
      true
    end
  end

  def judge_a_message
  end

  def show_current_sum
    puts "#{@name}の現在の得点は#{@hand.sum}です。"
  end

  def show_total
    puts "#{@name}の最終の得点は#{@hand.sum}です。"
  end
end

class HumanPlayer < Participant
  def judge_a_message
    puts 'ブラックジャックを終了します。'
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

class ComputerPlayer < Participant
end

class Dealer < Participant
  def initialize(name)
    super(name)
    @second_card_suit = ''
    @second_card_value = ''
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

  def judge_a_message
    puts '残ったプレイヤーたちの勝ちです。ブラックジャックを終了します。'
  end

  def show_second_card
    puts "#{@name}の引いた2枚目のカードは#{@second_card_suit}の#{@second_card_value}でした。"
  end
end
