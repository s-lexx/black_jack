# frozen_string_literal: true

module BlackJack
  class Player
    attr_reader :cards, :name, :wallet
    attr_writer :hide_cards, :sit

    ACE_ADDITION = 10
    SAFE_LIMIT = 11
    ACE_NOMINAL = 1
    START_BALANCE = 100

    def initialize(name)
      #@balance = 100
      @wallet = Wallet.new(START_BALANCE)
      @cards = []
      @name = name
    end

    def score
      ace_count = 0
      @cards.each { |card| ace_count += 1 if card.value == ACE_NOMINAL }
      score = @cards.sum(&:value)
      score += ACE_ADDITION if ace_count.positive? && score <= SAFE_LIMIT
      score
    end

    def hit(card)
      @cards << card
    end

    def sit?
      @sit
    end

    def bet(amount)
      @wallet.withdraw(amount)
    end

    def hide_cards?
      @hide_cards
    end
  end
end
