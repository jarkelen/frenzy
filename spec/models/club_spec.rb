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

  describe "scopes" do
    let!(:setting) { create(:setting, current_period: 1) }
    let!(:game)    { create :game, name: "Clubs Frenzy" }
    let!(:league)  { create(:league) }
    let!(:periods) { create_list(:period, 4) }
    let!(:player)  { create(:player, team_value: 125) }
    let!(:club1)    { create(:club, club_name: "Arsenal", league: league, period1: 25) }
    let!(:club2)    { create(:club, club_name: "Everton", league: league, period1: 10) }

    describe "own" do
      let!(:selection){ create(:selection, club: club1, player: player) }

      it "adds selected club to scope" do
        Club.own(player).should include(club1)
      end

      it "omits not selected club from scope" do
        Club.own(player).should_not include(club2)
      end
    end

    describe "selectable" do
      let!(:player2) { create(:player, team_value: 125) }
      let!(:club3)   { create(:club, club_name: "Fulham", league: league, period1: 15) }

      describe "available teamvalue" do
        let!(:selection) { create(:selection, club: club1, player: player) }

        it "should include clubs with lower value than remaining teamvalue" do
          Club.selectable(player, 95).should include(club2, club3)
        end

        it "should include clubs with the same value than remaining teamvalue" do
          Club.selectable(player, 115).should include(club2)
          Club.selectable(player, 115).should_not include(club1, club3)
        end

        it "should not include clubs with higher value than remaining teamvalue" do
          Club.selectable(player, 112).should include(club2)
          Club.selectable(player, 112).should_not include(club1, club3)
        end
      end

      describe "duplicate clubs" do
        let!(:player2) { create(:player, team_value: 125) }
        let!(:selection) { create(:selection, club: club2, player: player) }
        let!(:selection) { create(:selection, club: club3, player: player2) }

        it "should not show already selected clubs" do
          Club.selectable(player, 50).should_not include(club2)
        end

      end
    end
  end
end
