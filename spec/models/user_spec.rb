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

  describe "validations" do
    before do
      @user = User.new(first_name: "John", last_name: "Van Arkelen", team_name: "The Addicks", email: "john@bla.com", role: "user", language: "nl", team_value: 125)
    end

    describe "when last_name is too long" do
      before { @user.last_name = "a" * 51 }
      it { should_not be_valid }
    end

    describe "with a password that's too short" do
      before { @user.password = "a" * 5 }
      it { should be_invalid }
    end

    describe "when password is not present" do
      before { @user.password = "" }
      it { should_not be_valid }
    end

    describe "when email address is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                       foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          @user.email = invalid_address
          @user.should_not be_valid
        end
      end
    end

  end

  describe "methods" do

    before :each do
      FactoryGirl.create_list :period, 4
    end

    describe "admin?" do

      before :each do
        FactoryGirl.create :setting
      end

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

      before :each do
        FactoryGirl.create :setting
      end

      it "should create a full name" do
        user = FactoryGirl.create :user, first_name: "Piet", last_name: "Jansen"
        user.full_name.should == "Piet Jansen"
      end
    end

    describe "assign_jokers" do

      before :each do
        FactoryGirl.create :setting
      end

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

    describe "check protocol" do
      before :each do
        FactoryGirl.create :setting
        FactoryGirl.create_list :period, 4
      end

      context "bare website" do
        it "should add www and http protocol" do
          user = FactoryGirl.create :user, website: "test.nl"
          user.website.should == "http://www.test.nl"
        end
      end

      context "www website" do
        it "should add http protocol" do
          user = FactoryGirl.create :user, website: "www.test.nl"
          user.website.should == "http://www.test.nl"
        end
      end

      context "correct website" do
        it "should add nothing" do
          user = FactoryGirl.create :user, website: "http://www.test.nl"
          user.website.should == "http://www.test.nl"
        end
      end
    end

    describe "check twitter" do
      before :each do
        FactoryGirl.create :setting
        FactoryGirl.create_list :period, 4
      end

      context "twitter without dollar sign" do
        it "should show twitter user url" do
          user = FactoryGirl.create :user, twitter: "DutchAddick"
          user.twitter.should == "DutchAddick"
        end
      end

      context "twitter with dollar sign" do
        it "should show twitter user url" do
          user = FactoryGirl.create :user, twitter: "@DutchAddick"
          user.twitter.should == "DutchAddick"
        end
      end
    end

  end

end