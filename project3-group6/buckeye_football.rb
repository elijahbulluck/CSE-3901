require 'mechanize'
require 'nokogiri'
require_relative 'game'

class BuckeyeFootball
    def football_schedule(url)
        mechanize = Mechanize.new
        page = mechanize.get(url)
        body = Nokogiri::HTML(page.body)
        wins = page.at('span.record_wins').text
        losses = page.at('span.record_losses').text
        puts page.title
        puts "----------------------------------------------------------"
        puts "Current Record: #{wins}-#{losses}"
        puts ""

        opponents = []

        # Extract the locations
        locations = page.search('a.s-text-paragraph-small-underline')[0...13]
        vs_teams = page.search('a.text-theme-safe')[0..13]
        puts "Here's the football schedule from the beginning - November:\n\n"
        stadiums = []
        vs_teams.zip(locations).each do |team, ln|
            puts "Ohio State vs #{team.text} at #{ln.text}"
            stadiums << ln.text
        end

        body.search('a.text-theme-safe.s-text-paragraph-bold.block').each do |a_element|
            opponents << a_element.text.strip
        end

        dates = []
        score_data = []

        body.search('span').each do |span_element|
            text = span_element.text.strip
            if text =~ (/(W|L), (\d+-\d+)/)
                score_data << text
            elsif text =~ /(Sep|Oct|Nov|Dec|Jan) \d{1,2}/
                dates << text
            end
        end
        
        valid_months = ["Sep", "Oct", "Nov", "Dec", "Jan"]
        paragraphs = body.search('p.text-theme-safe.s-text-paragraph-bold')
        paragraphs.each do |paragraph|
            text = paragraph.text.strip
            dates << text
        end 
        
        times = []

        body.search('span.s-text-paragraph-small.text-theme-muted.flex.items-center.whitespace-nowrap').each do |span_element|
            times << span_element.text.strip
        end


        home_or_away = []
        span_elements = body.search('span.s-stamp__text.text-center.s-text-small-bold')
        span_elements.each do |span|
            text = span.text.strip
                    if text == "<!--[-->at<!--]-->"
                        home_or_away << "at"
                    elsif text == "<!--[-->vs<!--]-->"
                        home_or_away << "vs"
                    end
        end

        # Creating game object for each game
        @games = []
        game_count = 0
        while game_count < opponents.length
            score = game_count < score_data.length ? score_data[game_count] : nil
            @games << Game.new(dates[game_count], times[game_count], opponents[game_count], stadiums[game_count], score)
            game_count += 1
        end
        print_games()
    end

    def print_games
        puts "\nPast Games:"
        puts ""
        @games.each_with_index do |game|
            if game.score
                puts "#{game}"
            end
        end
        
        puts ""
        puts "Upcoming Games:"
        puts ""
        @games.each_with_index do |game|
            unless game.score
                puts "#{game}"
            end
        end
        puts "----------------------------------------------------------"
    end
end