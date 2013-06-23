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
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :player_id    }
  it { should validate_presence_of :club_id      }
  it { should belong_to(:gameround) }
  it { should belong_to(:player)    }
  it { should belong_to(:club)      }

  describe ".validate_jokers" do
    before :each do
      @gameround  = FactoryGirl.create(:gameround)
      @club1      = FactoryGirl.create(:club)
      @club2      = FactoryGirl.create(:club)
      @club3      = FactoryGirl.create(:club)
    end

    it "should be successful with valid parameters" do
      Joker.validate_jokers(@gameround, @club1, @club2, @club3).should be_true
    end

    it "should include a gameround" do
      Joker.validate_jokers(nil, @club1, @club2, @club3).should be_false
    end

    it "should fail when first 2 clubs are equal" do
      Joker.validate_jokers(@gameround, @club1, @club1, @club3).should be_false
    end

    it "should fail when last 2 clubs are equal" do
      Joker.validate_jokers(@gameround, @club1, @club2, @club2).should be_false
    end

    it "should fail when first and last clubs are equal" do
      Joker.validate_jokers(@gameround, @club1, @club2, @club1).should be_false
    end

    it "should fail when joker already exists" do
      FactoryGirl.create :setting
      @player = FactoryGirl.create(:player)
      FactoryGirl.create(:joker, player: @player, club: @club1, gameround: @gameround)
      Joker.validate_jokers(@gameround, @club1, nil, nil).should be_false
    end
  end

  describe ".joker_found" do
    before :each do
      FactoryGirl.create :setting
      @gameround  = FactoryGirl.create(:gameround)
      @club       = FactoryGirl.create(:club)
    end

    it "should return true when joker not already exists" do
      Joker.joker_found(@gameround, @club).should be_false
    end

    it "should return false when joker already exists" do
      @player = FactoryGirl.create(:player)
      FactoryGirl.create(:joker, player: @player, club: @club, gameround: @gameround)
      Joker.joker_found(@gameround, @club).should be_true
    end
  end
end
