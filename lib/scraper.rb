require 'open-uri'

class Scraper

  def initialize(results_date)
    @base_url = "http://www.bbc.co.uk"
    @results_date = results_date
  end

  def get_results(league)

    # Saturday 4th May 2013

    page = Nokogiri::HTML(open("#{@base_url}/sport/football/#{league}/results"))
    puts page.text
    #return page.at_css(".table-h caption").text.strip
=begin
    page.css(".table-header").each do |item|
      if item.text.strip == @results_date
        puts item.text.strip

        news_links = page.css("a").select{|link| link['data-category'] == "news"}
        #news_links.each{|link| puts link['href'] }
        puts news_links
      end
      #puts item.at_css(".prodLink").text
    end
    return news_links
=end
  end
end


