# == Schema Information
#
# Table name: jokers
#
#  id           :integer          not null, primary key
#  gameround_id :integer
#  user_id      :integer
#  club_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  player_id    :integer
#

require 'spec_helper'

describe Joker do
  let!(:setting) { create(:setting, current_period: 1) }
  let!(:game)    { create :game, name: "Clubs Frenzy" }
  let!(:gameround) { create :gameround }
  let!(:club1)     { create :club }
  let!(:club2)     { create :club }
  let!(:club3)     { create :club }
  let!(:club4)     { create :club }
  let!(:player)    { create(:player, team_value: 125) }
  let!(:joker)     { create(:joker, player: player, club: club4, gameround: gameround) }

  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :player_id    }
  it { should validate_presence_of :club_id      }
  it { should belong_to(:gameround) }
  it { should belong_to(:player)    }
  it { should belong_to(:club)      }

  describe ".validate_jokers" do
    it "succeeds with valid parameters" do
      Joker.validate_jokers(gameround, club1, club2, club3).should be_true
    end

    it "fails when a gameround is not included" do
      Joker.validate_jokers(nil, club1, club2, club3).should be_false
    end

    it "fails when first 2 clubs are equal" do
      Joker.validate_jokers(gameround, club1, club1, club3).should be_false
    end

    it "fails when last 2 clubs are equal" do
      Joker.validate_jokers(gameround, club1, club2, club2).should be_false
    end

    it "fails when first and last clubs are equal" do
      Joker.validate_jokers(gameround, club1, club2, club1).should be_false
    end

    it "fails when joker already exists" do
      Joker.validate_jokers(gameround, club4, nil, nil).should be_false
    end
  end

  describe ".joker_found" do
    it "returns true when joker not already exists" do
      Joker.joker_found(gameround, club2).should be_false
    end

    it "returns false when joker already exists" do
      Joker.joker_found(gameround, club4).should be_true
    end
  end
end
