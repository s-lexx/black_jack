# frozen_string_literal: true

require_relative '../../../lib/black_jack/game_view'
require_relative '../../../lib/black_jack/deck'
require_relative '../../../lib/black_jack'
require_relative '../../../lib/black_jack/card'
require_relative '../../../lib/black_jack/player'

describe BlackJack::GameView do
  let(:game_view) { described_class.new }
  let(:variants) { %i[sit hit open] }
  let(:deck) { BlackJack::Deck.new }
  let(:user) { BlackJack::User.new('Вася') }
  let(:dealer) { BlackJack::Dealer.new }


  describe 'greeting' do
    it 'displays a prompt for entering a name' do
      allow(game_view).to receive(:gets).and_return('Вася')
      expect { game_view.greeting }.to output("Введите свое имя:\n> ").to_stdout
      expect(game_view.user_name).to eq 'Вася'
    end
  end

  describe 'show_cards' do
    before do
      2.times { user.hit(deck.deal) }
    end

    it "returns correct score's" do
      re = /(10|[AJKQ2-9])[♦♥♣♠] (10|[AJKQ2-9])[♦♥♣♠]\n/
      expect { game_view.show_cards(user) }.to output(re).to_stdout
    end

    it 'returns hidden card value when hide_cards? = true' do
      user.hide_cards = true
      expect { game_view.show_cards(user) }.to output("* *\n").to_stdout
    end
  end

  describe 'show_score' do
    let(:face_card) { BlackJack::Card.new('♦', 'K', 10) }
    let(:ace_card) { BlackJack::Card.new('♦', 'A', 1) }
    let(:pip_card) { BlackJack::Card.new('♦', '5', 5) }

    it 'returns correct scores when user got a face card and an ace card' do
      user.hit(face_card)
      user.hit(ace_card)
      scores = "Счет игрока #{user.name}: 21\n"
      expect { game_view.show_score(user) }.to output(scores).to_stdout
    end

    it 'returns correct scores when user got a face card and a pip card' do
      user.hit(face_card)
      user.hit(pip_card)
      scores = "Счет игрока #{user.name}: 15\n"
      expect { game_view.show_score(user) }.to output(scores).to_stdout
    end
  end

  context 'user_input' do
    before do
      allow(game_view).to receive_messages(greeting: 'Вася', user_input: 1)
    end

    describe 'user_turn' do
      it 'user_turn return a correct value' do
        expect(game_view.user_turn(variants)).to eq :sit
      end
    end

    describe 'end_game?' do
      it 'user_input return a correct value' do
        expect(game_view.end_game?(user)).to be_falsey
      end
    end
  end

  describe 'dealer_turn' do
    it 'returns hit when score less then 17' do
      expect { game_view.dealer_turn(:hit) }.to output("Дилер взял карту\n").to_stdout
    end

    it 'returns sit when score more then 17' do
      expect { game_view.dealer_turn(:sit) }.to output("Дилер пропустил ход\n").to_stdout
    end
  end

  describe 'show_winner' do
    it 'returns drawn' do
      expect { game_view.show_winner(nil) }.to output("Ничья!\n").to_stdout
    end

    it 'returns wins player' do
      expect { game_view.show_winner(user) }.to output("В этом раунде победил Вася!\n").to_stdout
    end

    it 'returns wins dealer' do
      expect { game_view.show_winner(dealer) }.to output("В этом раунде победил Дилер!\n").to_stdout
    end
  end
end
