# frozen_string_literal: true

require_relative 'black_jack/player'
require_relative 'black_jack/card'
require_relative 'black_jack/dealer'
require_relative 'black_jack/user'
require_relative 'black_jack/wallet'
require_relative 'black_jack/deck'
require_relative 'black_jack/game_view'

module BlackJack
  class << self
    HAND_SIZE = 3
    END_GAME_VARIANTS = %i[Да Нет].freeze
    BET = 10

    def game
      setup

      loop do
        stop if @players[:user].wallet.balance.zero? || @players[:dealer].wallet.balance.zero?
        turn_preparation
        turn
        turn_finishing
        stop if @view.end_game?(user)
      end
    end

    private

    attr_reader :bank, :players

    def setup
      @bank = Wallet.new(0)
      @view = GameView.new
      @view.greeting
      @players = fetch_players
    end

    def fetch_players
      {
         user:   User.new(@view.user_name),
         dealer: Dealer.new
      }
    end

    def user
      players[:user]
    end

    def dealer
      players[:dealer]
    end

    def deal
      flush_cards
      @deck = Deck.new
      players.each_value do |player|
        player.sit = false
        2.times { player.hit(@deck.deal) }
      end
    end

    def flush_cards
      players.each_value { |player| player.cards.clear }
      dealer.hide_cards = true
    end

    def bet
      players.each_value { |player| player.wallet.transfer(@bank, BET) }
      puts "user - #{user.wallet.balance}, dealer #{dealer.wallet.balance}, bank #{@bank.balance}"
    end

    def turn_preparation
      deal
      bet
    end

    def turn
      actions = %i[sit hit open]

      2.times do |time|
        current_state
        user_choice = @view.user_turn(actions)
        user.hit(@deck.deal) if user_choice == :hit

        break if user_choice == :open

        @view.dealer_turn(dealer.choice) if time.zero?
        actions.delete(:sit)
        break if user.cards.size == HAND_SIZE
      end
    end

    def turn_finishing
      dealer.hide_cards = false
      current_state
      @winner = find_winner
      @view.show_winner(@winner)
      payout
    end

    def find_winner
      user_score = user.score - 21
      dealer_score = dealer.score - 21

      winner = user   if !user_score.positive? && (dealer_score.positive? || user_score > dealer_score)
      winner = dealer if !dealer_score.positive? && (user_score.positive? || dealer_score > user_score)
      winner
    end

    def payout
      if @winner.nil?
        players.each_value { |player| bank.transfer(player.wallet, BET) }
      else
        bank.transfer(@winner.wallet, bank.balance)
      end
    end

    def stop
      @view.show_winner(find_winner)
      @view.end_game
      exit 0
    end

    def current_state
      players.each_value do |player|
        @view.show_cards(player)
        @view.show_score(player) unless player.hide_cards?
      end
    end
  end
end
