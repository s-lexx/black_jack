# frozen_string_literal: true

require 'yaml'

module BlackJack
  class GameView
    attr_reader :user_name

    def initialize
      @messages = YAML.safe_load_file("#{__dir__}/cfg/messages.yaml", symbolize_names: true)
    end

    def greeting
      puts @messages[:view][:get_user_name]
      print '> '
      @user_name = gets.chomp
    end

    def show_cards(player)
      indexes = player.cards.map(&:index)
      hidden_cards = player.cards.map { '*' }
      puts (player.hide_cards? ? hidden_cards : indexes).join(' ')
    end

    def show_score(player)
      puts "#{@messages[:view][:user_score]} #{player.name}: #{player.score}"
    end

    def user_turn(variants)
      user_messages = @messages[:user].select { |key, _| variants.include?(key) }
      selection = user_input(@messages[:view][:select_actions], user_messages.values) - 1
      variants[selection]
    end

    def end_game?(player)
      user_balance = player.wallet.balance
      description = "#{@user_name}, #{@messages[:view][:user_balance]} #{user_balance}, #{@messages[:view][:more_turn]}"
      user_input(description, @messages[:black_jack].values) - 1 == 1
    end

    def end_game
      puts @messages[:view][:end_game]
    end

    def dealer_turn(choice)
      puts @messages[:dealer][choice]
    end

    def show_winner(player)
      puts player.nil? ? @messages[:view][:drawn_game] : "#{@messages[:view][:turn_winner]} #{player.name}!"
    end

    def user_input(description, variants)
      choice = nil
      loop do
        puts description
        show_variants(variants)
        print '> '
        choice = gets.chomp.to_i

        break unless choice.nil? || !choice.between?(1, variants.size)

        puts "\n\t#{@messages[:view][:wrong_input]} #{variants.size}!\n"
      end
      choice
    end

    private

    def show_variants(variants)
      variants.each_with_index { |variant, index| puts "#{index + 1}. #{variant}" }
    end
  end
end
