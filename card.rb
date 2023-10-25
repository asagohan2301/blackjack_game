# 残ったカードの情報を管理する。カードを参加者に渡す。
class Card
  attr_accessor :all_cards

  def initialize
    @all_cards = {
      spade: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
      heart: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
      diamond: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K'],
      club: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K']
    }
  end

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
end
