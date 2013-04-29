require 'spec_helper'

describe FrenzyCalculator do
  before :each do
    @calculator = FrenzyCalculator.new
  end

  describe "new" do
    it "returns a FrenzyCalculator object" do
      @calculator.should be_an_instance_of FrenzyCalculator
    end
  end
=begin
  describe "cancel jokers" do
    @gameround1 = FactoryGirl.create(:gameround, number: 1)
    @gameround2 = FactoryGirl.create(:gameround, number: 2)
    @joker1 = FactoryGirl.create(:joker, gameround: @gameround1)
    @joker2 = FactoryGirl.create(:joker, gameround: @gameround2)
    @club = FactoryGirl.create(:club)

    it "should cancel joker of cancelled gameround" do
      line = []
      line[:home_club_id] = @club.id
      line[:gameround_id] = @gameround1.id

      #expect { @calculator.cancel_jokers(line) }.to change{Joker.count}.from(2).to(1)
    end
  end
=end
end

