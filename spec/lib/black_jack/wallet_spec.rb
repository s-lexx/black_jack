# frozen_string_literal: true

require_relative '../../../lib/black_jack/wallet'

describe BlackJack::Wallet do
  let(:wallet) { described_class.new(20) }

  describe 'withdraw' do
    it 'creates wallet with start balance' do
      expect(wallet.balance).to eq 20
    end

    it 'withdraws balance' do
      expect(wallet.withdraw(10)).to eq 10
      expect(wallet.balance).to eq 10
    end
  end

  describe 'refill' do
    it 'refills balance' do
      expect(wallet.refill(10)).to eq 30
      expect(wallet.balance).to eq 30
    end
  end

  describe 'transfer' do
    it 'transfer value between wallets' do
      wallet_2 = described_class.new(0)
      wallet.transfer(wallet_2, 10)
      expect(wallet.balance).to eq 10
      expect(wallet_2.balance).to eq 10
    end
  end
end
