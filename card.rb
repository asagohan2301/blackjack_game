# Card クラス：残りのカードを管理 / 参加者にカードを渡す
class Card
  attr_reader :suit, :value, :number, :suit_ja

  def initialize
    @deck = {
      spade: ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
      heart: ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
      diamond: ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
      club: ['A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']
    }
    # その時に参加者が引いたカード1枚の情報が入る
    @suit = ''
    @suit_ja = ''
    @value = nil
    @number = 0
  end

  def shuffle
    @suit = set_suit
    @suit_ja = set_suit_ja
    @value = set_value
    @number = set_number
  end

  private

  def set_suit
    case rand(4)
    when 0 then @suit = :spade
    when 1 then @suit = :heart
    when 2 then @suit = :diamond
    when 3 then @suit = :club
    end
  end

  def set_suit_ja
    {
      spade: 'スペード',
      heart: 'ハート',
      diamond: 'ダイヤ',
      club: 'クラブ'
    }[@suit]
  end

  def set_value
    @value = @deck[@suit].delete_at(rand(@deck[@suit].length))
  end

  def set_number
    @number = if %w[J Q K].include?(@value)
                10
              elsif @value == 'A'
                11
              else
                @value
              end
  end
end
