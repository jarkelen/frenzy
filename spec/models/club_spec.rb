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
    let!(:setting) { create(:setting) }
    let!(:periods) { create_list(:period, 4) }
    let!(:player)  { create(:player, team_value: 125) }
    let!(:league)  { create(:league) }
    let!(:club1)   { create(:club, league: league, period1: 10) }
    let!(:club2)   { create(:club, league: league, period1: 25) }
    let!(:club3)   { create(:club, league: league, period1: 15) }

    describe "available teamvalue" do
      let!(:selection) { create(:selection, club: club1, player: player) }

      it "should include clubs with lower value than remaining teamvalue" do
        Club.selectable(player, 95).should include(club1, club2, club3)
      end

      it "should include clubs with the same value than remaining teamvalue" do
        Club.selectable(player, 115).should include(club1)
        Club.selectable(player, 115).should_not include(club2, club3)
      end

      it "should not include clubs with higher value than remaining teamvalue" do
        Club.selectable(player, 112).should include(club1)
        Club.selectable(player, 112).should_not include(club2, club3)
      end
    end

    describe "duplicate clubs" do
      let!(:selection) { create(:selection, club: club1, player: player) }

      it "should show not yet selected clubs" do
        Club.selectable(player, 50).should include(club2, club3)
      end

      it "should not show already selected clubs" do
        Club.selectable(player, 50).should_not include(club1)
      end
    end
  end
end
