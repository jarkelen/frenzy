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
  let!(:game)      { create :game, name: "Clubs Frenzy" }

  it { should have_many(:jokers)     }
  it { should have_many(:rankings)   }
  it { should have_many(:selections) }
  it { should have_many(:clubs).through(:selections) }
  it { should have_many(:scores).through(:clubs) }
  it { should belong_to(:user) }
  it { should belong_to(:game) }

  describe "assign_jokers" do
    context "period1" do
      let!(:setting) { create(:setting, current_period: 1, max_jokers: 40) }
      let!(:player)    { create(:player) }

      it "assigns 40 jokers" do
        player.assigned_jokers == 40
      end
    end

    context "period2" do
      let!(:setting) { create(:setting, current_period: 2, max_jokers: 30) }
      let!(:player)    { create(:player) }

      it "assigns 30 jokers" do
        player.assigned_jokers == 30
      end
    end

    context "period3" do
      let!(:setting) { create(:setting, current_period: 3, max_jokers: 20) }
      let!(:player)    { create(:player) }

      it "assigns 20 jokers" do
        player.assigned_jokers == 20
      end
    end

    context "period4" do
      let!(:setting) { create(:setting, current_period: 4, max_jokers: 10) }
      let!(:player)    { create(:player) }

      it "assigns 10 jokers" do
        player.assigned_jokers == 10
      end
    end
  end

  describe "set_participation_due" do
    context "participation open" do
      let!(:setting){ create(:setting, current_period: 1, max_jokers: 40, participation: true) }
      let!(:player) { create(:player) }

      it "leaves participation_due empty" do
        player.set_participation_due.should == nil
      end
    end

    context "participation closed" do
      let!(:setting){ create(:setting, current_period: 1, max_jokers: 40, participation: false) }
      let!(:player) { create(:player) }

      it "sets participation_due to 3 days ago" do
        player.set_participation_due.to_s.should == 3.days.from_now.to_s
      end
    end
  end

  describe "participation_restricted?" do
    context "team size" do
      let!(:setting)  { create(:setting, current_period: 1, max_jokers: 40, max_teamsize: 25) }
      let!(:player)   { create(:player) }

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
      let!(:player)   { create(:player) }

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

      context "access restricted" do
        let!(:setting)  { create(:setting, current_period: 1, max_jokers: 40, participation: false) }
        let!(:player)   { create(:player, participation_due: nil) }

        it "restricts access for existing users when participation is closed" do
          player.participation_restricted?(20, 124).should be_true
        end
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
