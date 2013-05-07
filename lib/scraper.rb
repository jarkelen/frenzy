require 'open-uri'

class Scraper

  def initialize
    @base_url = "http://www.bbc.co.uk"
  end

  def get_results(results_date, league)

    # Saturday 4th May 2013

    page = Nokogiri::HTML(open("#{@base_url}/sport/football/#{league}/results"))
    #puts page.at_css(".table-h caption").text.strip

    page.css(".table-header").each do |item|
      if item.text.strip == results_date
        puts item.text.strip
        return true
      end
      #puts item.at_css(".prodLink").text
    end
  end
end


