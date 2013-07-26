# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  base_nr            :integer
#  first_name         :string(255)
#  last_name          :string(255)
#  team_name          :string(255)
#  email              :string(255)      not null
#  language           :string(255)
#  role               :string(255)      default("user")
#  team_value         :integer          default(125)
#  assigned_jokers    :integer
#  encrypted_password :string(128)      not null
#  confirmation_token :string(128)
#  remember_token     :string(128)      not null
#  participation_due  :datetime
#  location           :string(255)
#  website            :string(255)
#  bio                :string(255)
#  facebook           :string(255)
#  twitter            :string(255)
#  favorite_club      :integer
#  birth_date         :datetime
#

require 'spec_helper'

describe User do
  it { should validate_presence_of :role       }
  it { should validate_presence_of :email      }
  it { should validate_presence_of :language   }
  it { should validate_presence_of :team_value  }
  it { should have_many(:newsitems) }
  it { should have_many(:players) }
  it { should have_many(:games).through(:players) }

  describe "validations" do
    let!(:setting){ create(:setting, max_jokers: 40) }
    let!(:period) { create_list(:period, 4) }
    let!(:game)   { create :game, name: "Clubs Frenzy" }
    let!(:user)   { create :user, first_name: "John", last_name: "Van Arkelen", team_name: "The Addicks", role: "user", language: "nl" }

    describe "when last_name is too long" do
      before { user.last_name = "a" * 51 }
      it { should_not be_valid }
    end

    describe "with a password that's too short" do
      before { user.password = "a" * 5 }
      it { should be_invalid }
    end

    describe "when password is not present" do
      before { user.password = "" }
      it { should_not be_valid }
    end

    describe "when email address is already taken" do
      before do
        user_with_same_email = user.dup
        user_with_same_email.email = user.email.upcase
        user_with_same_email.save
      end

      it { should_not be_valid }
    end

    describe "when email format is invalid" do
      it "should be invalid" do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                       foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          user.email = invalid_address
          user.should_not be_valid
        end
      end
    end

  end

  describe "methods" do
    let!(:setting){ create(:setting, max_jokers: 40) }
    let!(:game)   { create :game, name: "Clubs Frenzy" }
    let!(:period) { create_list(:period, 4) }
    let!(:user)   { create :user, first_name: "John", last_name: "Van Arkelen", team_name: "The Addicks", role: "user", language: "nl", base_nr: 1  }
    let!(:admin)   { create :user, first_name: "John", last_name: "Van Arkelen", team_name: "The Addicks", role: "admin", language: "nl", base_nr: 2  }

    describe "admin?" do
      it "should return true if admin" do
        admin.admin?.should be_true
      end

      it "should return false if regular user" do
        user = FactoryGirl.create :user, role: "user"
        user.admin?.should be_false
      end
    end

    describe "full_name" do
      it "should create a full name" do
        user.full_name.should == "John Van Arkelen"
      end
    end

    describe "get_prizes" do
      let!(:player1) { create(:player, cups: 0, medals: 1, rosettes: 3, user: user) }
      let!(:player2) { create(:player, cups: 1, medals: 3, rosettes: 7, user: user) }

      it "gets all cups" do
        user.get_prizes("cup").should == 1
      end

      it "gets all medals" do
        user.get_prizes("medal").should == 4
      end

      it "gets all rosettes" do
        user.get_prizes("rosette").should == 10
      end
    end

    describe "assign_base_nr" do
      let!(:user2)   { create :user }

      it "assigns proper base_nr" do
        user2.base_nr.should == 3
      end
    end

    describe "check protocol" do
      context "bare website" do
        let!(:user)   { create :user, website: "test.nl" }

        it "should add www and http protocol" do
          user.website.should == "http://www.test.nl"
        end
      end

      context "www website" do
        let!(:user)   { create :user, website: "www.test.nl" }

        it "should add http protocol" do
          user.website.should == "http://www.test.nl"
        end
      end

      context "correct website" do
        let!(:user)   { create :user, website: "http://www.test.nl" }

        it "should add nothing" do
          user.website.should == "http://www.test.nl"
        end
      end
    end

    describe "check twitter" do
      context "twitter without dollar sign" do
        let!(:user)   { create :user, twitter: "DutchAddick" }

        it "should show twitter user url" do
          user.twitter.should == "DutchAddick"
        end
      end

      context "twitter with dollar sign" do
        let!(:user)   { create :user, twitter: "@DutchAddick" }

        it "should show twitter user url" do
          user.twitter.should == "DutchAddick"
        end
      end
    end

  end

end
