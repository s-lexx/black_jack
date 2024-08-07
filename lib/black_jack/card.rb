# frozen_string_literal: true

module BlackJack
  class Card
    attr_reader :value, :index

    def initialize(suit, rank, value)
      @value = value
      @index = "#{rank}#{suit}"
    end
  end
end
