# frozen_string_literal: true

require_relative '../../../lib/black_jack/player'
require_relative '../../../lib/black_jack/dealer'
require_relative '../../../lib/black_jack/wallet'
require_relative '../../../lib/black_jack/card'

describe BlackJack::Dealer do
  let(:dealer) { described_class.new }

  describe 'choice' do
    before do
      dealer.hit(BlackJack::Card.new('♥', 'J', 10))
    end

    it 'returns :hit when score less than 17' do
      expect(dealer.choice).to eq :hit
    end

    it 'returns :sit when score more than 17' do
      dealer.hit(BlackJack::Card.new('♥', '8', 8))
      expect(dealer.choice).to eq :sit
    end
  end
end
