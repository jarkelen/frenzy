require 'spec_helper'
require 'fakeweb'

describe Scraper do
  before :each do
    @scraper = Scraper.new(1)
  end

  describe "new" do
    it "returns a Scraper object" do
      @scraper.should be_an_instance_of Scraper
    end
  end

  describe "get_results" do
    before :each do
      body = "<table class='table-stats'>
                <td class='match-details'>
                  <p>
                    <span class='team-home teams'>
                      <a href='http://www.bbc.co.uk/sport/football/teams/birmingham-city'>Birmingham</a>
                    </span>
                    <span class='score'> <abbr title='Score'> 1-1 </abbr> </span>
                    <span class='team-away teams'>
                      <a href='http://www.bbc.co.uk/sport/football/teams/blackburn-rovers'>Blackburn</a>
                    </span>
                  </p>
                </td>"
      FakeWeb.register_uri(:get, "http://www.bbc.co.uk/sport/football/championship/results", body: body)
    end

    it "should return error when league is empty" do
      @scraper.get_results("").should == :no_league
    end

    it "should return error when no results are found" do
      @scraper.get_results("bla").should == :no_league
    end

    it "should return match results" do
      @scraper.get_results("The Championship").should be_a_kind_of(Array)
      @scraper.get_results("The Championship").should include({"home_club"=>"**Birmingham**", "home_score"=>"1", "away_club"=>"**Blackburn**", "away_score"=>"1"})
    end
  end

  describe "match_clubname" do
    let!(:club) { create :club, club_name: "Charlton Athletic" }

    it "should return false when no club can be found" do
      @scraper.match_clubname("Birmingham").should == "**Birmingham**"
    end

    it "should match whole name" do
      @scraper.match_clubname("Charlton Athletic").should == "Charlton Athletic"
    end

    it "should match partial name" do
      @scraper.match_clubname("Charlton").should == "Charlton Athletic"
    end

    it "should match abbreviated name" do
      @scraper.match_clubname("Charlton Athl").should == "Charlton Athletic"
    end
  end

  describe "convert_league" do
    it "should return premier league" do
      @scraper.convert_league("Premier League").should == "premier-league"
    end

    it "should return championship" do
      @scraper.convert_league("The Championship").should == "championship"
    end

    it "should return league one" do
      @scraper.convert_league("League One").should == "league-one"
    end

    it "should return league two" do
      @scraper.convert_league("League Two").should == "league-two"
    end

    it "should return conference" do
      @scraper.convert_league("Blue Square Premier League").should == "conference"
    end

    it "should return error when empty" do
      @scraper.convert_league("").should == nil
    end
  end
end

