require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = doc.css(".student-card")
    students.map do |student|
      {:name => student.css(".student-name").text,
        :location => student.css(".student-location").text,
        :profile_url => student.css("a").first['href']}
    end

  end

  def self.scrape_profile_page(profile_url)
    #profile_url = ./fixtures/student-site/students/joe-burgess.html
    doc = Nokogiri::HTML(open(profile_url))
    links = (doc.css('.social-icon-container')).css('a')
    profile_quote = doc.css('.profile-quote').text
    bio = (doc.css('.description-holder')).css('p').text
    student_hash = {}

    links.map do |link|
      if link['href'].include?('twitter')
        student_hash[:twitter] = link['href']
      elsif link['href'].include?('linkedin')
        student_hash[:linkedin] = link['href']
      elsif link['href'].include?('github')
          student_hash[:github] = link['href']
      elsif link['href'].include?('facebook')
        student_hash[:facebook] = link['href']
      else
        student_hash[:blog] = link['href']

      end
      student_hash[:profile_quote] = profile_quote
      student_hash[:bio] = bio

    end

    student_hash
   end

end
