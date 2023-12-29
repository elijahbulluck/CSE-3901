# Project 3 - Web Scraper

Project Description:
>This program is a simple web scraper of an Ohio State website that gives some sort of functionality to the users. We chose to go with the sports page and implement some features that make it easy to view who the Ohio State Buckeyes are going to be playing in the upcoming weeks. Our base functionality is to scrape and order the football schedule, both past games and upcoming in order to show some specific details about them. In the future we plan to implement this for more sports so that there can be a comprehensive visual at the glance of an eye that lets users know what they want to know when they want it.

Technologies Utilized:
>This project is written in Ruby and makes use of the Mechanize and Nokogiri gems, both which were very useful for capturing the information on this webpage. The Mechanize gem makes it easy to interface with a webpage and use functions like extraction or link clicking to navigate around the data. Nokogiri is similar but focuses more on the HTML itself and the parsing and manipulation associated with it. In order to more effectively traverse through the HTML on the page web we found it easiest to display it all in one file that we would be able to reference throughout the project. This is reflected in the 'assests' folder where you will find 'football_page.html' that shows what the webpage we chose looks like in standard HTML. Here we were able to pick out certain elements with ease and efficiently display the most relevant data

Challenges Faced:
>Some of the challenges we faced were more so with group dynamic and less of the project itself. Since this program isn't very long, it was hard to delegate roles to one another so what we decided was that we would all tinker with these gems and then come together, compare our code, and merge them into something that was a combination of all of them. In addition, we learned how to navigate our busy schedules and find consistent times when we could meet in order to collaborate.

Running the Program:
>To run the program, simply type 'ruby main.rb' into the command line and the main file will call any and all subsequent files

>Thank you for taking the time to read this and use our web scraper!
