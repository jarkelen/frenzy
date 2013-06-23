# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  club_name  :string(255)
#  period1    :integer
#  period2    :integer
#  period3    :integer
#  period4    :integer
#  league_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
  it { should have_many(:home_results) }
  it { should have_many(:away_results) }
  it { should have_many(:jokers) }
  it { should belong_to(:league) }

  describe ".selectable" do
    let!(:setting) { create(:setting) }
    let!(:periods) { create_list(:period, 4) }
    let!(:player1) { create(:player, team_value: 125) }
    let!(:player2) { create(:player, team_value: 125) }
    let!(:league)  { create(:league) }
    let!(:club1)   { create(:club, club_name: "Arsenal", league: league, period1: 10) }
    let!(:club2)   { create(:club, club_name: "Everton", league: league, period1: 25) }
    let!(:club3)   { create(:club, club_name: "Fulham", league: league, period1: 15) }

    describe "available teamvalue" do
      let!(:selection) { create(:selection, club: club1, player: player1) }

      xit "should include clubs with lower value than remaining teamvalue" do
        Club.selectable(player1, 95).should include(club1, club2, club3)
      end

      xit "should include clubs with the same value than remaining teamvalue" do
        Club.selectable(player1, 115).should include(club1)
        Club.selectable(player1, 115).should_not include(club2, club3)
      end

      xit "should not include clubs with higher value than remaining teamvalue" do
        Club.selectable(player1, 112).should include(club1)
        Club.selectable(player1, 112).should_not include(club2, club3)
      end
    end

    describe "duplicate clubs" do
      let!(:selection) { create(:selection, club: club1, player: player1) }
      let!(:selection) { create(:selection, club: club2, player: player2) }

      xit "should show not yet selected clubs" do
        Club.selectable(player1, 50).should include(club2, club3)
      end

      xit "should not show already selected clubs" do
        Club.selectable(player1, 50).should_not include(club1)
      end

      xit "should show already selected clubs by other user" do
        Club.selectable(player1, 50).should include(club2)
      end
    end
  end
end
