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
    student_hash = {}
    link_array = []
    blog_link = nil
    social_networks = ["twitter", "github", "linkedin"]
    doc = get_doc(profile_url)
    social_icon_container = doc.css(".social-icon-container")
    links = social_icon_container.xpath("//a")
    image_links = links.xpath("//img")
    image_urls = image_links.map {|link| link[:src]}
    
    links.each do |link|
      blog_link = link[:href] if link.css("img[src='../assets/img/rss-icon.png']").count == 1
      link_array << link[:href]
    end
    
    link_array.each do |link|
      social_networks.each do |network|
        student_hash[network.to_sym] =  link if link.include?(network)
      end
    end
   
    student_hash[:blog] = blog_link if blog_link
    student_hash[:profile_quote] = doc.css(".profile-quote").text
    student_hash[:bio] = doc.css(".bio-content p").text
    student_hash
  end
  
  def self.get_doc(url)
    Nokogiri::HTML(open(url))
  end

end
