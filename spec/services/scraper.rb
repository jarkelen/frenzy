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
                      <a href='http://www.bbc.co.uk/sport/football/teams/burnley'>Burnley</a>
                    </span>
                    <span class='score'> <abbr title='Score'> 1-2 </abbr> </span>
                    <span class='team-away teams'>
                      <a href='http://www.bbc.co.uk/sport/football/teams/qpr'>QPR</a>
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
#      @scraper.get_results("The Championship").should include({"home_club"=>"Burnley", "home_score"=>"1", "away_club"=>"Queens Park Rangers", "away_score"=>"2"})
      @scraper.get_results("The Championship").should_not include({"away_club"=>"***qpr***"})
    end
  end
end

