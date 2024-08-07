# frozen_string_literal: true

require_relative '../../../lib/black_jack/deck'
require_relative '../../../lib/black_jack/card'

describe BlackJack::Deck do
  let(:deck) { described_class.new }

  describe 'generate_cards' do
    it('have 52 cards') do
      expect(deck.cards.size).to eq 52
    end

    it('have 4 Ace') do
      expect(deck.cards.count { |card| card.value == 1 }).to eq 4
    end

    it('have 13 cards each suit') do
      expect(deck.cards.count { |card| card.index.include?('♦') }).to eq 13
    end
  end

  describe 'deal' do
    it('deal card and remove it from deck') do
      card = deck.deal
      expect(deck.cards.size).to eq 51
      expect(deck.cards).not_to include(card)
    end
  end
end
