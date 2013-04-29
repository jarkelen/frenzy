require 'spec_helper'

describe Profile do
  it { should validate_presence_of :user_id }
  it { should belong_to(:user) }

  describe "check protocol" do
    before :each do
      FactoryGirl.create :setting
      FactoryGirl.create_list :period, 4
      @user = FactoryGirl.create :user
    end

    context "bare website" do
      it "should add www and http protocol" do
        profile = FactoryGirl.create :profile, website: "test.nl", user: @user
        profile.website.should === "http://www.test.nl"
      end
    end

    context "www website" do
      it "should add http protocol" do
        profile = FactoryGirl.create :profile, website: "www.test.nl", user: @user
        profile.website.should === "http://www.test.nl"
      end
    end

    context "correct website" do
      it "should add nothing" do
        profile = FactoryGirl.create :profile, website: "http://www.test.nl", user: @user
        profile.website.should === "http://www.test.nl"
      end
    end
  end

  describe "check twitter" do
    before :each do
      FactoryGirl.create :setting
      FactoryGirl.create_list :period, 4
      @user = FactoryGirl.create :user
    end

    context "twitter without dollar sign" do
      it "should show twitter profile url" do
        profile = FactoryGirl.create :profile, twitter: "DutchAddick", user: @user
        profile.twitter.should === "DutchAddick"
      end
    end

    context "twitter with dollar sign" do
      it "should show twitter profile url" do
        profile = FactoryGirl.create :profile, twitter: "@DutchAddick", user: @user
        profile.twitter.should === "DutchAddick"
      end
    end
  end

end


