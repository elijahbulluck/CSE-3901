require_relative 'player_creator'
require_relative 'game_creator'

class Game

    def initialize
       @player_creator = PlayerCreator.new
       @game_creator = GameCreator.new
    end

    def add_players
        @players = @player_creator.get_players
        puts "Welcome #{@players.join(' and ')}"
    end
    
    def start
        @deck = @game_creator.get_deck
        @hand = @game_creator.deal_hand(@deck)
    end   
end
