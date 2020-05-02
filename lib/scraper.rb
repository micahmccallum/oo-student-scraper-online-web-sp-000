require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_array = []
    doc = get_doc(index_url)
    doc.css(".student-card").each do |student_profile|
      student = {
        :name => student_profile.css(".student-name").text,
        :location => student_profile.css(".student-location").text,
        :profile_url => student_profile.css("a").first["href"]
      }
      student_array << student
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    doc = get_doc(profile_url)
    social_icons = doc.css(".social-icon-container")
    twitter = social_icons.css("a[href*='twitter']").first["href"]
    linkedin = social_icons.css("a[href*='linkedin']").first["href"]
    github = social_icons.css("a[href*='github']").first["href"]
    blog = social_icons.xpath("//a").last["href"]
    profile_quote = doc.css(".profile-quote").text
    bio = doc.css(".bio-content p").text
    student_hash = {
      :twitter => twitter,
      :linkedin => linkedin,
      :github => github,
      :blog => blog,
      :profile_quote => profile_quote,
      :bio => bio
    }
  end
  
  def self.get_doc(url)
    Nokogiri::HTML(open(url))
  end
    

end
