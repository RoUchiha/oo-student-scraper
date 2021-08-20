require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = URI.open(index_url)

    index = Nokogiri::HTML(html)

    students = []
   
    index.css('.roster-cards-container .student-card').each do |s|
      
      students << {
        :name => s.css(' .card-text-container h4.student-name').text,
        :location => s.css(' .card-text-container p.student-location').text,
        :profile_url => s.css(' a').attribute('href').value
      }
    end
    return students
  end

  def self.scrape_profile_page(profile_url)
    html = URI.open(profile_url)

    profile = Nokogiri::HTML(html)

    student = {}

    social = profile.css('.social-icon-container').css('a').collect { |m| m.attributes['href'].value }

    social.detect do |n|
      student[:twitter] = n if n.include?("twitter")
      student[:linkedin] = n if n.include?("linkedin")
      student[:github] = n if n.include?("github")
      
    end
    student[:blog] = social[3] if social[3] != nil
    student[:profile_quote] = profile.css('.vitals-text-container').css('.profile-quote').text
    student[:bio] = profile.css('.details-container').css('p').text       
    return student

      
    
  end


  

end

