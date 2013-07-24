# == Schema Information
#
# Table name: players
#
#  id                :integer          not null, primary key
#  rosettes          :integer          default(0)
#  medals            :integer          default(0)
#  cups              :integer          default(0)
#  user_id           :integer
#  game_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  team_value        :integer          default(125)
#  assigned_jokers   :integer
#  participation_due :datetime
#

require 'spec_helper'

describe Player do
  let!(:period)    { create_list(:period, 4) }

  it { should have_many(:jokers)     }
  it { should have_many(:rankings)   }
  it { should have_many(:selections) }
  it { should have_many(:clubs).through(:selections) }
  it { should have_many(:scores).through(:clubs) }
  it { should belong_to(:user) }
  it { should belong_to(:game) }

  describe "assign_jokers" do
    let!(:setting_1) { create(:setting, current_period: 1, max_jokers: 40) }
    let!(:setting_2) { create(:setting, current_period: 2, max_jokers: 40) }
    let!(:setting_3) { create(:setting, current_period: 3, max_jokers: 40) }
    let!(:setting_4) { create(:setting, current_period: 4, max_jokers: 40) }
    let!(:game)      { create :game, name: "Clubs Frenzy" }
    let!(:player)    { create(:player) }

    it "should be assigned 40 jokers" do
      player.assigned_jokers == 40
    end

    it "should be assigned 30 jokers" do
      player.assigned_jokers == 30
    end

    it "should be assigned 20 jokers" do
      player.assigned_jokers == 20
    end

    it "should be assigned 20 jokers" do
      player.assigned_jokers == 10
    end
  end

  describe "set_participation_due" do
    let!(:setting_true)  { create(:setting, current_period: 1, max_jokers: 40, participation: true) }
    let!(:setting_false) { create(:setting, current_period: 1, max_jokers: 40, participation: false) }
    let!(:player)        { create(:player) }

    it "should leave participation_due empty when participation still open" do
      player.set_participation_due.should == nil
    end
  end

  describe "participation_restricted?" do
    context "team size" do
      let!(:setting)  { create(:setting, current_period: 1, max_jokers: 40, max_teamsize: 25) }
      let!(:player)        { create(:player) }

      it "should allow access when team size is smaller than max teamsize" do
        player.participation_restricted?(24, 100).should be_false
      end

      it "should restrict access when team size is equal to max teamsize" do
        player.participation_restricted?(25, 100).should be_true
      end

      it "should restrict access when team size is larger than max teamsize" do
        player.participation_restricted?(26, 100).should be_true
      end
    end

    context "team value" do
      let!(:setting)  { create(:setting, current_period: 1, max_jokers: 40, max_teamvalue: 125) }
      let!(:player)        { create(:player) }

      it "should allow access when team value is smaller than max teamvalue" do
        player.participation_restricted?(20, 124).should be_false
      end

      it "should restrict access when team value is equal to max teamvalue" do
        player.participation_restricted?(20, 125).should be_true
      end

      it "should restrict access when team value is larger than max teamvalue" do
        player.participation_restricted?(20, 126).should be_true
      end
    end

    context "participation due" do
      let!(:setting)  { create(:setting, current_period: 1, max_jokers: 40) }
      let!(:player)   { create(:player) }

      it "should allow access for existing users when participation is open" do
        player.participation_due = nil
        player.participation_restricted?(20, 124).should be_false
      end

      xit "should restrict access for existing users when participation is closed" do
        setting.participation = false
        player.participation_restricted?(20, 124).should be_true
      end

      it "should allow access for new users when participation is closed" do
        player.participation_due = 3.days.from_now
        player.participation_restricted?(20, 124).should be_false
      end

      it "should restrict access for new users when participation is closed and due date has passed" do
        player.participation_due = 1.day.ago
        player.participation_restricted?(20, 124).should be_true
      end
    end
  end

end
