require 'open-uri'
require 'nokogiri'

class Scraper

  def initialize(iterations)
    @base_url = "http://www.bbc.co.uk"
    @iterations = iterations
  end

  def get_results(league)
    begin
      league = convert_league(league)
      raise "no_league" if league.nil?

      match_results = []
      page = Nokogiri::HTML(open("#{@base_url}/sport/football/#{league}/results"))
      counter = 0
      while counter < @iterations
        table = page.css(".table-stats")[counter]
        results = table.css("td.match-details")
        unless results.empty?
          results.each do |result|
            match_result = Hash.new
            match_result["home_club"]   = result.css("span.team-home a").text.strip
            match_result["home_score"]  = result.css("span.score abbr").text.strip.split("-")[0]
            match_result["away_club"]   = result.css("span.team-away a").text.strip
            match_result["away_score"]  = result.css("span.score abbr").text.strip.split("-")[1]
            match_results << match_result
          end
        else
          raise "no_results"
        end
        counter += 1
      end
      return match_results
    rescue
      return :error
    end
  end

  def convert_league(league)
    case league
      when "Premier League"
        "premier-league"
      when "The Championship"
        "championship"
      when "League One"
        "league-one"
      when "League Two"
        "league-two"
      when "Blue Square Premier League"
        "conference"
      else
        nil
    end
  end
end


scraper = Scraper.new(1)
results = scraper.get_results("championship")
puts results
