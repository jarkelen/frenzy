require 'spec_helper'

describe Player do
  it { should have_many(:jokers)     }
  it { should have_many(:rankings)   }
  it { should have_many(:selections) }
  it { should have_many(:clubs).through(:selections) }
  it { should belong_to(:user) }
  it { should belong_to(:match) }

  describe "assign_jokers" do
    let(:user) { create(:user) }

    it "should be assigned 40 jokers" do
      FactoryGirl.create :setting, current_period: 1, max_jokers: 40
      player.assigned_jokers == 40
    end

    it "should be assigned 30 jokers" do
      FactoryGirl.create :setting, current_period: 2, max_jokers: 40
      player.assigned_jokers == 30
    end

    it "should be assigned 20 jokers" do
      FactoryGirl.create :setting, current_period: 3, max_jokers: 40
      player.assigned_jokers == 20
    end

    it "should be assigned 20 jokers" do
      FactoryGirl.create :setting, current_period: 4, max_jokers: 40
      player.assigned_jokers == 10
    end
  end

  describe "set_participation_due" do
    it "should leave participation_due empty when participation still open" do
      FactoryGirl.create :setting, current_period: 1, max_jokers: 40, participation: true
      user = FactoryGirl.create :user
      user.set_participation_due.should == nil
    end

    it "should fill participation_due when participation is closed" do
      FactoryGirl.create :setting, current_period: 1, max_jokers: 40, participation: false
      user = FactoryGirl.create :user
      DateTime.parse(user.set_participation_due.to_s).should == DateTime.parse(3.days.from_now.to_s)
    end
  end

  describe "participation_restricted?" do
    context "team size" do
      it "should allow access when team size is smaller than max teamsize" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, max_teamsize: 25
        user = FactoryGirl.create :user
        user.participation_restricted?(24, 100).should be_false
      end

      it "should restrict access when team size is equal to max teamsize" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, max_teamsize: 25
        user = FactoryGirl.create :user
        user.participation_restricted?(25, 100).should be_true
      end

      it "should restrict access when team size is larger than max teamsize" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, max_teamsize: 25
        user = FactoryGirl.create :user
        user.participation_restricted?(26, 100).should be_true
      end
    end

    context "team value" do
      it "should allow access when team value is smaller than max teamvalue" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, max_teamvalue: 125
        user = FactoryGirl.create :user
        user.participation_restricted?(20, 124).should be_false
      end

      it "should restrict access when team value is equal to max teamvalue" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, max_teamvalue: 125
        user = FactoryGirl.create :user
        user.participation_restricted?(20, 125).should be_true
      end

      it "should restrict access when team value is larger than max teamvalue" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, max_teamvalue: 125
        user = FactoryGirl.create :user
        user.participation_restricted?(20, 126).should be_true
      end
    end

    context "participation due" do
      it "should allow access for existing users when participation is open" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, participation: true
        user = FactoryGirl.create :user, participation_due: nil
        user.participation_restricted?(20, 124).should be_false
      end

      it "should restrict access for existing users when participation is closed" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, participation: false
        user = FactoryGirl.create :user
        user.participation_due = nil
        user.participation_restricted?(20, 124).should be_true
      end

      it "should allow access for new users when participation is closed" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, participation: false
        user = FactoryGirl.create :user
        user.participation_due = 3.days.from_now
        user.participation_restricted?(20, 124).should be_false
      end

      it "should restrict access for new users when participation is closed and due date has passed" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40, participation: false
        user = FactoryGirl.create :user
        user.participation_due = 1.day.ago
        user.participation_restricted?(20, 124).should be_true
      end
    end
  end

end
