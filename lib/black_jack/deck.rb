# frozen_string_literal: true

require_relative 'card'
require_relative 'wallet'

module BlackJack
  class Deck
    attr_reader :cards

    def initialize
      generate_cards
    end

    def deal
      @cards.delete(@cards.sample)
    end

    private

    SUITS = ['♦', '♥', '♣', '♠']
    FACE_CARDS = ['J', 'Q', 'K']
    PIP_CARDS = 2..10
    ACE_CARD = 'A'

    def generate_cards
      @cards = []

      SUITS.each do |suit|
        @cards << Card.new(suit, ACE_CARD, 1)
        PIP_CARDS.each { |card| @cards << Card.new(suit, card.to_s, card) }
        FACE_CARDS.each { |card| @cards << Card.new(suit, card, 10) }
      end
    end
  end
end
