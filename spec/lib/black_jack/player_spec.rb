# frozen_string_literal: true

require_relative '../../../lib/black_jack/player'
require_relative '../../../lib/black_jack/card'
require_relative '../../../lib/black_jack/wallet'

describe BlackJack::Player do
  let(:player) { described_class.new('Петя') }
  let(:face_card) { BlackJack::Card.new('♦', 'K', 10) }
  let(:ace_card) { BlackJack::Card.new('♦', 'A', 1) }
  let(:pip_card) { BlackJack::Card.new('♦', '5', 5) }

  describe 'score' do
    it "calculate 11 score's on ace-card when scores less than 21" do
      player.hit(face_card)
      player.hit(ace_card)
      expect(player.score).to eq 21
    end

    it 'calculate 1 score on ace-card when scores more than 21' do
      player.hit(face_card)
      player.hit(ace_card)
      player.hit(BlackJack::Card.new('♦', '5', 5))
      expect(player.score).to eq 16
    end
  end

  describe 'sit' do
    it 'allows change value' do
      expect(player).not_to be_sit
      player.sit = true
      expect(player).to be_sit
    end
  end

  describe 'hide_cards?' do
    it 'allows change value' do
      expect(player).not_to be_hide_cards
      player.hide_cards = true
      expect(player).to be_hide_cards
    end
  end
end
