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
    let!(:setting)  { create :setting }
    let!(:periods)  { create_list :period, 4 }
    let!(:user)     { create :user, team_value: 125 }
    let!(:league)   { create :league }
    let!(:club1)    { create :club, club_name: "Arsenal", league: league, period1: 10 }
    let!(:club2)    { create :club, club_name: "Everton", league: league, period1: 25 }
    let!(:club3)    { create :club, club_name: "Fulham", league: league, period1: 15 }

    describe "available teamvalue" do
      it "should include clubs with lower value than remaining teamvalue" do
        Club.selectable(user, 95).should include(club1, club2, club3)
      end

      it "should include clubs with the same value than remaining teamvalue" do
        Club.selectable(user, 115).should include(club1)
        Club.selectable(user, 115).should_not include(club2, club3)
      end

      it "should not include clubs with higher value than remaining teamvalue" do
        Club.selectable(user, 112).should include(club1)
        Club.selectable(user, 112).should_not include(club2, club3)
      end
    end

    describe "duplicate clubs" do
      let!(:user2)     { create :user, team_value: 125 }
      let!(:selection) { create :selection, club: club1, user: user }
      let!(:selection) { create :selection, club: club2, user: user2 }

      it "should show not yet selected clubs" do
        Club.selectable(user, 50).should include(club2, club3)
      end

      it "should not show already selected clubs" do
        Club.selectable(user, 50).should_not include(club1)
      end

      it "should show already selected clubs by other user" do
        Club.selectable(user, 50).should include(club2)
      end
    end
  end
end
