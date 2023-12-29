require_relative 'game'

class GameCreator
    SHAPES = [:diamond, :squiggle, :oval]
    NUMBERS = [:one, :two, :three]
    SHADINGS = [:solid, :striped, :open]
    COLORS = [:red, :green, :purple]

    def get_deck
    deck = []
    SHAPES.each do |shape|
        NUMBERS.each do |number|
            SHADINGS.each do |shading|
                COLORS.each do |color|
                deck << { shape: shape, number: number, shading: shading, color: color }
                end
            end
        end
    end
    deck.shuffle!
    end

    def check_for_valid_set?(deck, current_hand)
        valid_set = hand_has_set?(current_hand)
        while valid_set == false

            if deck.length >= 3 
               puts "No valid sets in the current hand. Adding 3 more cards."
               add_cards_to_player_hand(deck, current_hand) 
            else
              puts "No valid sets in the hand, and there are not enough cards in the deck left." 
              return false
            end 
            valid_set = hand_has_set?(current_hand)
        end
        return true
    end

    def deal_hand(deck)
        yes_or_no = ask_for_timer
        current_hand = deck.shift(12)
        check_for_valid_set?(deck, current_hand)
        puts "Current Hand:"
        current_hand.each_with_index do |card, index|
            puts "#{index + 1}: Shape: #{card[:shape]}, Number: #{card[:number]}, Shading: #{card[:shading]}, Color: #{card[:color]}"
        end
        get_player_input(deck, current_hand, yes_or_no)    
    end

    def is_set?(card1, card2, card3)
        shapes = [card1[:shape], card2[:shape], card3[:shape]]
        numbers = [card1[:number], card2[:number], card3[:number]]
        shadings = [card1[:shading], card2[:shading], card3[:shading]]
        colors = [card1[:color], card2[:color], card3[:color]]
        return (shapes.uniq.length == 1 || shapes.uniq.length == 3) &&
        (numbers.uniq.length == 1 || numbers.uniq.length == 3) &&
        (shadings.uniq.length == 1 || shadings.uniq.length == 3) &&
        (colors.uniq.length == 1 || colors.uniq.length == 3)
    end
    
    def add_cards_to_player_hand(deck, current_hand)
        current_hand.concat(deck.shift(3))
    end

    def hand_has_set?(current_hand)
        (0...current_hand.length - 2).each do |i|
            (i + 1...current_hand.length - 1).each do |j|
              (j + 1...current_hand.length).each do |k|
                if is_set?(current_hand[i], current_hand[j], current_hand[k])
                    return true
                end
                end
            end
        end
        return false
    end

    def ask_for_timer
        puts "Would you like to have a 5 minute timer for the game? Enter yes or no:"
        yes_or_no = gets.chomp
        while yes_or_no.downcase != "yes" && yes_or_no.downcase != "no"
            puts "Would you like to have a 5 minute timer for the game? Enter 'yes' or 'no':"
            yes_or_no = gets.chomp 
        end
        return yes_or_no
    end

    def get_player_input(deck, current_hand, yes_or_no)
        start_time = nil
        end_time = nil
        if yes_or_no.downcase == "yes"
            game_duration = 300
            end_time = Time.now + game_duration
            puts "5 minutes on the clock!"
        else
            end_time = Time.now + (10 ** 10)
            puts "Starting game without 5-minute timer."
        end
        player1_score = 0
        player2_score = 0
        while (current_hand.length >= 3) && Time.now < end_time
            puts "Type 'Set' to select a set in the hand, or 'Quit' if both players give up:"
            player_response = gets.chomp 
            while player_response.downcase != "set" && player_response.downcase != "quit"
                puts "Invalid response. Type 'Set' to select a set in the hand, or 'Quit' if both players give up:"
                player_response = gets.chomp 
            end
            if player_response.downcase == "quit"
                break
            end
            puts "Enter the numbers of the cards of the set, separated by spaces. For example, '1 2 3'"
            card_numbers = gets.chomp.split(' ').map(&:to_i)
            while card_numbers.length != 3 && !card_numbers.all?{ |index| index.between?(1, current_hand.length) }
                puts "Invalid input. Enter the numbers of the cards of the set, separated by spaces. For example, '1 2 3'"
                card_numbers = gets.chomp.split(' ').map(&:to_i)
            end
            cards_for_set = card_numbers.map {|index| current_hand[index - 1]}
            if is_set?(cards_for_set[0],cards_for_set[1], cards_for_set[2])
                puts "Congratulations! You have found a set."
                player1_score, player2_score = add_player_points(player1_score, player2_score)
                cards_for_set.each { |card| current_hand.delete(card)}
                if deck.length >= 3 
                    puts "Removing the cards from the hand and adding 3 more from the deck...\n"
                    add_cards_to_player_hand(deck, current_hand)
                    valid_set = check_for_valid_set?(deck, current_hand)
                    if valid_set == false
                        break
                    end
                    if yes_or_no.downcase == "yes"
                    time_remaining = (end_time - Time.now).to_i
                    puts "Time Remaining: #{format_time(time_remaining)}"
                    sleep(1)
                    end
                    puts "Current Hand:"
                    current_hand.each_with_index do |card, index|
                            puts "#{index + 1}: Shape: #{card[:shape]}, Number: #{card[:number]}, Shading: #{card[:shading]}, Color: #{card[:color]}"
                    end
                else
                    puts "There are no more cards left in the deck."
                    valid_set = check_for_valid_set?(deck, current_hand)
                    if valid_set == false
                        break
                    end
                    puts "Current Hand:"
                    current_hand.each_with_index do |card, index|
                        puts "#{index + 1}: Shape: #{card[:shape]}, Number: #{card[:number]}, Shading: #{card[:shading]}, Color: #{card[:color]}"
                    end
                end
            else
                puts "The cards you entered do not form a set. Keeping the cards in the hand."
                puts "Current Hand:"
                    current_hand.each_with_index do |card, index|
                        puts "#{index + 1}: Shape: #{card[:shape]}, Number: #{card[:number]}, Shading: #{card[:shading]}, Color: #{card[:color]}"
                    end
            end
        end
            puts "Game Over!"
        if player1_score > player2_score
            puts "Player 1 wins!"
        elsif player1_score < player2_score
            puts "Player 2 wins!"
        elsif player1_score == player2_score 
            puts "It's a tie!"
        end
    end

    def add_player_points(player1_score, player2_score)
        puts "Which player are you? Player 1 or Player 2? (Enter '1' or '2'):"
        player_num = gets.chomp 
            while player_num != '1' && player_num != '2'
                puts "Invalid input. Please enter your player number."
                puts "Which player are you? Player 1 or Player 2? (Enter '1' or '2'):"
                player_num = gets.chomp 
            end
            if player_num == '1'
                player1_score += 1
                puts "Player 1 scores a point!\nTotal scores:\nPlayer 1 - #{player1_score}\nPlayer 2 - #{player2_score}"
              elsif player_num == '2'
                player2_score += 1
                puts "Player 2 scores a point!\nTotal scores:\nPlayer 1 - #{player1_score}\nPlayer 2 - #{player2_score}"
            end
            return player1_score, player2_score
    end

    def format_time(seconds)
        minutes = seconds / 60
        seconds = seconds % 60
        "#{minutes}:#{format('%02d', seconds)}"
    end
end