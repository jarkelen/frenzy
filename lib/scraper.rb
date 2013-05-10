require 'open-uri'
require 'nokogiri'

class Scraper

  def initialize(iterations)
    @base_url = "http://www.bbc.co.uk"
    @iterations = iterations
  end

  def get_results(league)
    league = convert_league(league)
    return :no_league if league.nil?

    page = Nokogiri::HTML(open("#{@base_url}/sport/football/#{league}/results"))
    match_results = []
    counter = 0
    while counter < @iterations
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
    case club_name
      when "Man City"
        club = Club.where("club_name LIKE ?", "Manchester City").first
      when "Wolves"
        club = Club.where("club_name LIKE ?", "Wolverhampton Wanderers").first
      when "Nottm Forest"
        club = Club.where("club_name LIKE ?", "Nottingham Forest").first
      when "Sheff Wed"
        club = Club.where("club_name LIKE ?", "Sheffield Wednesday").first
      when "sheff utd"
        club = Club.where("club_name LIKE ?", "Sheffield United").first
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