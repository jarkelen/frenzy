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
      @player = FactoryGirl.create :player, team_value: 125
      @league = FactoryGirl.create :league
      @club1 = FactoryGirl.create :club, league: @league, period1: 10
      @club2 = FactoryGirl.create :club, league: @league, period1: 25
      @club3 = FactoryGirl.create :club, league: @league, period1: 15
      @selection = FactoryGirl.create :selection, club: @club1, player: @player
    end

    describe "available teamvalue" do
      xit "should include clubs with lower value than remaining teamvalue" do
        Club.selectable(@player, 95).should include(@club1, @club2, @club3)
      end

      xit "should include clubs with the same value than remaining teamvalue" do
        Club.selectable(@player, 115).should include(@club1)
        Club.selectable(@player, 115).should_not include(@club2, @club3)
      end

      xit "should not include clubs with higher value than remaining teamvalue" do
        Club.selectable(@player, 112).should include(@club1)
        Club.selectable(@player, 112).should_not include(@club2, @club3)
      end
    end

    describe "duplicate clubs" do
      it "should show not yet selected clubs" do
        Club.selectable(@player, 50).should include(@club2, @club3)
      end

      it "should not show already selected clubs" do
        Club.selectable(@player, 50).should_not include(@club1)
      end
    end
  end
end
