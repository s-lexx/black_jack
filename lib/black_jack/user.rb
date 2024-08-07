# frozen_string_literal: true

module BlackJack
  class User < Player
    def initialize(name)
      super(name)
      @hide_cards = false
    end
  end
end

