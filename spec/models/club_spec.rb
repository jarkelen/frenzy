require 'spec_helper'

describe Club do
  it { should validate_presence_of :club_name }
  it { should validate_presence_of :league_id }
  it { should validate_presence_of :period1   }
  it { should validate_presence_of :period2   }
  it { should validate_presence_of :period3   }
  it { should validate_presence_of :period4   }
  it { should have_many(:scores) }
  it { should have_many(:selections) }
  it { should have_many(:jokers) }
  it { should belong_to(:league) }

  describe ".selectable" do
    #let(:setting) { create :setting }
    #let(:periods) { create_list :period, 4 }
    before :each do
      FactoryGirl.create :setting
      FactoryGirl.create_list :period, 4
      @user = FactoryGirl.create :user, team_value: 125
      @league = FactoryGirl.create :league
      @club1 = FactoryGirl.create :club, league: @league, period1: 10
      @club2 = FactoryGirl.create :club, league: @league, period1: 25
      @club3 = FactoryGirl.create :club, league: @league, period1: 15
    end

    it "should include clubs with lower value than remaining teamvalue" do
      Club.selectable(@user, 95).should include(@club1, @club2, @club3)
    end

    it "should include clubs with the same value than remaining teamvalue" do
      Club.selectable(@user, 115).should include(@club1)
      Club.selectable(@user, 115).should_not include(@club2, @club3)
    end

    it "should not include clubs with higher value than remaining teamvalue" do
      Club.selectable(@user, 112).should include(@club1)
      Club.selectable(@user, 112).should_not include(@club2, @club3)
    end

  end
end
