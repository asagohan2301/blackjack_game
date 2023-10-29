# Participant クラス：手札やチップ、スタンドの状態などを管理 / これらの情報の表示は Participant クラスが行う
class Participant
  TARGET_NUMBER = 21
  attr_reader :name, :hand, :is_bust

  def initialize(name)
    @name = name
    @hand = []
    @is_bust = false
  end

  def draw_card(card)
    card.shuffle
    draw_card_message(card.value, card.suit_ja)
    @hand.push(card.number)
  end

  def draw_card_message(value, suit_ja)
    puts "#{@name}の引いたカードは#{suit_ja}の#{value}です。"
  end

  def set_ace
    index = @hand.index(11)
    @hand[index] = 1
    puts "#{@name}の得点が#{TARGET_NUMBER}を超えたので、手札にあるAを1とします。得点は#{@hand.sum}になります。"
  end

  def bust
    @is_bust = true
    puts "#{@name}の得点が#{TARGET_NUMBER}を超えました。#{@name}は負けました。"
  end

  def show_current_sum
    puts "#{@name}の現在の得点は#{@hand.sum}です。"
  end

  def show_total
    puts "#{@name}の得点は#{@hand.sum}です。"
  end
end

class Player < Participant
  attr_reader :is_stand, :is_double_down

  def initialize(name)
    super(name)
    @is_stand = false
    @chip = 0
    @balance = 10
    @is_double_down = 'undecided'
  end

  def show_balance
    puts "#{@name}の残りのチップは#{@balance}枚です。"
  end

  def confirm_chip
    puts 'チップを何枚賭けますか？'
    @chip = gets.chomp.to_i
    while @chip > @balance || @chip <= 0
      puts '残りのチップ以下の正の整数を入力してください。'
      puts 'チップを何枚賭けますか？'
      @chip = gets.chomp.to_i
    end
    @balance -= @chip
  end

  def confirm_double_down
    puts 'ダブルダウンしますか？賭けるチップを2倍(足りない場合は全額)にし、カードはあと1枚だけ引きます。（Y/N）'
    @is_double_down = gets.chomp
    while %w[Y N].include?(@is_double_down) == false
      puts 'YかNを入力してください。'
      puts 'ダブルダウンしますか？'
      @is_double_down = gets.chomp
    end
    return if @is_double_down == 'N'

    if @chip * 2 > @balance + @chip
      @chip = @balance + @chip
      @balance = 0
    else
      @balance -= @chip
      @chip += @chip
    end
    puts "賭けるチップを#{@chip}枚にします。"
  end

  def confirm_continue
    puts 'カードを引きますか？（Y/N）'
    response = gets.chomp
    while %w[Y N].include?(response) == false
      puts 'YかNを入力してください。'
      puts 'カードを引きますか？（Y/N）'
      response = gets.chomp
    end
    if response == 'Y'
      true
    elsif response == 'N'
      false
    end
  end

  def stand
    @is_stand = true
    puts "#{@name}はカードを引き終えました。得点は#{@hand.sum}です。"
  end

  def settle_bet(result)
    case result
    when 'win'
      puts "賭けたチップの2倍を得ます。#{@name}は#{@chip * 2}枚チップを得ました。"
      @balance += @chip * 2
    when 'draw'
      puts "賭けたチップがそのまま戻ってきます。#{@name}は#{@chip}枚チップを得ました。"
      @balance += @chip
    when 'lose'
      puts '賭けたチップは没収されます。'
    end
  end
end

class Dealer < Participant
  attr_reader :minimum

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

  def show_second_card
    puts "#{@name}の引いた2枚目のカードは#{@second_card_suit}の#{@second_card_value}でした。"
  end
end
