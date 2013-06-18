require 'spec_helper'

describe User do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name  }
  it { should validate_presence_of :team_name  }
  it { should validate_presence_of :role       }
  it { should validate_presence_of :email      }
  it { should validate_presence_of :language   }
  it { should validate_presence_of :team_value  }
  it { should have_many(:newsitems) }
  it { should have_many(:players) }
  it { should have_many(:games).through(:players) }

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