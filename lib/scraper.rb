require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
      students = []
      # index_page.css("div.roster-cards-container").each do |card|
      #   card.css(".student-card a").each do |student|
      #     student_name = student.css('.student-name').text
      #     student_location = student.css('.student-location').text
      #     student_profile_url = "#{student.attr('href')}"
      #     students << {name: student_name, location: student_location, profile_url: student_profile_url}

      index_page.css("div.roster-cards-container").each do |card|
        card.css(".student-card a").each do |student|
          student_profile_link = "#{student.attr('href')}"
          student_location = student.css('.student-location').text
          student_name = student.css('.student-name').text
          students << {name: student_name, location: student_location, profile_url: student_profile_link}
        end
      end
      students
    end

  def self.scrape_profile_page(profile_url)
      student = {}
      profile = Nokogiri::HTML(open(profile_url))
      # binding.pry
      links = profile.css(".social-icon-container").children.css("a").map{ |l| l.attribute('href').value}
      links.each do |link|  
        if link.include?("linkedin")
          student[:linkedin] = link
        elsif link.include?("twitter")
          student[:twitter] = link
        elsif link.include?("github")
          student[:github] = link
        else
          student[:blog] = link
        # binding.pry
        end
      end
      student[:profile_quote] = profile.css(".profile-quote").text if profile.css(".profile-quote")
      # binding.pry
      student[:bio] = profile.css("div.bio-content.content-holder div.description-holder p").text if student[:bio] = profile.css("div.bio-content.content-holder div.description-holder p")
      student
  end

end

