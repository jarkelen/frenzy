require 'open-uri'
require 'nokogiri'

class Scraper
  attr_reader :base_url, :iterations

  def initialize(iterations)
    @base_url = "http://www.bbc.co.uk"
    @iterations = iterations
  end

  def get_results(league)
    league = convert_league(league)
    return :no_league if league.nil?

    page = Nokogiri::HTML(open("#{base_url}/sport/football/#{league}/results"))
    match_results = []
    counter = 0
    while counter < iterations
      table = page.css(".table-stats")[counter]
      results = table.css("td.match-details")
      unless results.empty?
        results.each do |result|
          match_results << retrieve_match_result(result)
        end
      else
        return :no_results
      end
      counter += 1
    end
    match_results
  end

  private

    def retrieve_match_result(result)
      match_result = Hash.new
      match_result["home_club_id"] = match_club("id", result.css("span.team-home a").text.strip)
      match_result["home_club"]    = match_club("name", result.css("span.team-home a").text.strip)
      match_result["home_score"]   = result.css("span.score abbr").text.strip.split("-")[0]
      match_result["away_club_id"] = match_club("id", result.css("span.team-away a").text.strip)
      match_result["away_club"]    = match_club("name", result.css("span.team-away a").text.strip)
      match_result["away_score"]   = result.css("span.score abbr").text.strip.split("-")[1]
      return match_result
    end

    def match_club(type, club_name)
      club_names = Hash.new
      club_names["man city"]              = "Manchester City"
      club_names["man utd"]               = "Manchester United"
      club_names["qpr"]                   = "Queens Park Rangers"
      club_names["wolves"]                = "Wolverhampton Wanderers"
      club_names["nottm forest"]          = "Nottingham Forest"
      club_names["sheff wed"]             = "Sheffield Wednesday"
      club_names["sheff utd"]             = "Sheffield United"
      club_names["west brom"]             = "West Bromwich Albion"
      club_names["west ham"]              = "West Ham United"
      club_names["oxford utd"]            = "Oxford United"
      club_names["fleetwood"]             = "Fleetwood Town"
      club_names["dag & red"]             = "Dagenham & Redbridge"
      club_names["newport"]               = "Newport County"
      club_names["braintree"]             = "Braintree Town"
      club_names["alfreton"]              = "Alfreton Town"
      club_names["nuneaton"]              = "Nuneaton Borough"
      club_names["hyde"]                  = "Hyde United"
      club_names["woking"]                = "Woking"
      club_names["dag & red"]             = "Dagenham and Redbridge"

      if club_names.has_key?(club_name.downcase)
        club = Club.where("club_name LIKE ?", club_names[club_name.downcase]).first
      else
        club = Club.where("club_name LIKE ?", "%#{club_name}%").first
      end

      if club
        if type == "name"
          club.club_name
        else
          club.id
        end
      else
        if type == "name"
          "***#{club_name}***"
        else
          0
        end
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