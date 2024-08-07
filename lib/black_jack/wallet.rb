# frozen_string_literal: true

module BlackJack
  class Wallet
    class EmptyWalletError < ::StandardError
    end

    attr_reader :balance

    def initialize(start_balance)
      @balance = start_balance
    end

    def withdraw(value)
      raise EmptyWalletError if @balance.zero?

      @balance -= value
    end

    def refill(value)
      @balance += value
    end

    def transfer(receiver, value)
      withdraw(value)
      receiver.refill(value)
    end
  end
end
