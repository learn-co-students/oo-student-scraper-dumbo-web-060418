require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.load_page(url)
    html = File.read(url)
    Nokogiri::HTML(html)
  end

  def self.scrape_index_page(index_url)
    page = Scraper.load_page(index_url)

    profiles = []

    page.css("div.student-card").each do |student|
      student_info = {
        name: student.css("h4.student-name").text,
        location: student.css("div.card-text-container p.student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
      profiles << student_info
    end

    profiles
  end

  def self.scrape_profile_page(profile_url)
    page = Scraper.load_page(profile_url)

    student = {
      profile_quote: page.css("div.vitals-text-container div.profile-quote").text,
      bio: page.css("div.bio-block div.bio-content div.description-holder p").text,
    }

    unless page.css("div.social-icon-container [href*='twitter']").empty?
      student[:twitter] = page.css("div.social-icon-container [href*='twitter']").attribute("href").value
    end
    unless page.css("div.social-icon-container [href*='github']").empty?
      student[:github] = page.css("div.social-icon-container [href*='github']").attribute("href").value
    end
    unless page.css("div.social-icon-container [href*='linkedin']").empty?
      student[:linkedin] = page.css("div.social-icon-container [href*='linkedin']").attribute("href").value
    end
    unless page.css("div.social-icon-container a:nth-of-type(4)").empty?
      student[:blog] = page.css("div.social-icon-container a:nth-of-type(4)").attribute("href").value
    end

    student
  end

end

#students = Scraper.scrape_index_page("fixtures/student-site/index.html")
#johnny = Scraper.scrape_profile_page("fixtures/student-site/students/johnny-ramos.html")
#binding.pry

# name: student.css("h4.student-name").text,
# location: student.css("div.card-text-container p.student-location").text,
# profile_url: student.css("a").attribute("href").value

# profile_quote: page.css("div.vitals-text-container div.profile-quote").text
# bio: page.css("div.bio-block div.bio-content div.description-holder p").text


### Do not know how to make these work ###
# twitter: page.css("div.social-icon-container [href*='twitter']").attribute("href").value
# linkedin: page.css("div.social-icon-container a:nth-of-type(2)").attribute("href").value
# github: page.css("div.social-icon-container a:nth-of-type(3)").attribute("href").value
