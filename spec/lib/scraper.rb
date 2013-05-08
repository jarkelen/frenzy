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
      FakeWeb.register_uri(:get, "http://www.bbc.co.uk/sport/football/championship/results", body: "Hello World!")
    end

    it "should return error when league is empty" do
      @scraper.get_results("").should == :error
    end

    it "should return error when no reuslts are found" do
      @scraper.get_results("bla").should == :error
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

