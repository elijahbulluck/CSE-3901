require_relative 'buckeye_football'

osu_website = BuckeyeFootball.new
website = 'https://ohiostatebuckeyes.com/sports/football/schedule'
osu_website.football_schedule(website)