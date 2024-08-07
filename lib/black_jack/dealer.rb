# frozen_string_literal: true

module BlackJack
  class Dealer < Player
    SCORE_LIMIT = 17

    def initialize(name = 'Дилер')
      super
    end

    def choice
      return :sit if score > SCORE_LIMIT

      :hit
    end
  end
end
