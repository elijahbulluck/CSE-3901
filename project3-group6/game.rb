# Added class by Zubin on 10/5/23 to manage scheduled games
class Game
    attr_reader :date, :time, :opponent, :score, :location

    def initialize(date, time, opponent, location, score = nil)
        @date = date
        @time = time
        @opponent = opponent
        @location = location
        @score = score
    end

    def to_s
        if location == "Ohio Stadium"
            formatted_opponent = "vs #{opponent}".ljust(20)
        else
            formatted_opponent = "@ #{opponent}".ljust(20)
        end

        # Use formatted string for consistent spacing, can play with these values more still, and adjust the output string
        formatted_date = "#{remove_day(date)}".ljust(10)
        formatted_location_and_time = "#{time} at #{location}".ljust(35)

        # Output is slightly different depending on if there is a score    
        if score
            "#{formatted_date} #{formatted_opponent} #{formatted_location_and_time} Score: #{score}"
        else
            "#{formatted_date} #{formatted_opponent} #{formatted_location_and_time}"
        end
    end
end

# Removes the day of the week part of date
# Nov 4 (Sat) - > Nov 4
def remove_day(input)
    out = input
    out = out.sub('(Mon)', '')
    out = out.sub('(Tue)', '')
    out = out.sub('(Wed)', '')
    out = out.sub('(Thu)', '')
    out = out.sub('(Fri)', '')
    out = out.sub('(Sat)', '')
    out = out.sub('(Sun)', '')
    out.strip
end