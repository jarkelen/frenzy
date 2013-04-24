require 'spec_helper'

describe User do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name  }
  it { should validate_presence_of :team_name  }
  it { should validate_presence_of :role       }
  it { should validate_presence_of :email      }
  it { should validate_presence_of :language   }
  it { should validate_presence_of :team_value  }
  it { should have_many(:jokers)     }
  it { should have_many(:rankings)   }
  it { should have_many(:selections) }
  it { should have_many(:clubs).through(:selections) }


  describe "methods" do
    before :each do
      FactoryGirl.create :setting
      FactoryGirl.create_list :period, 4
    end

    describe "admin?" do

      it "should return true if admin" do
        user = FactoryGirl.create :user, role: "admin"
        user.admin?.should be_true
      end

      it "should return false if regular user" do
        user = FactoryGirl.create :user, role: "user"
        user.admin?.should be_false
      end
    end

    describe "full_name" do
      it "should create a full name" do
        user = FactoryGirl.create :user, first_name: "Piet", last_name: "Jansen"
        user.full_name.should == "Piet Jansen"
      end
    end

    describe "assign jokers" do
      it "should be assigned 40 jokers" do
        FactoryGirl.create :setting, current_period: 1, max_jokers: 40
        user = FactoryGirl.create :user
        user.assigned_jokers == 40
      end

      it "should be assigned 30 jokers" do
        FactoryGirl.create :setting, current_period: 2, max_jokers: 40
        user = FactoryGirl.create :user
        user.assigned_jokers == 30
      end

      it "should be assigned 20 jokers" do
        FactoryGirl.create :setting, current_period: 3, max_jokers: 40
        user = FactoryGirl.create :user
        user.assigned_jokers == 20
      end

      it "should be assigned 20 jokers" do
        FactoryGirl.create :setting, current_period: 4, max_jokers: 40
        user = FactoryGirl.create :user
        user.assigned_jokers == 10
      end
    end
  end

end