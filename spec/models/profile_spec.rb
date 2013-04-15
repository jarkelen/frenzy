require 'spec_helper'

describe Profile do
  it { should validate_presence_of :user_id }
  it { should belong_to(:user) }

  describe "check protocol" do
    FactoryGirl.create :setting

    context "bare website" do
      it "should add www and http protocol" do
        profile = create :profile, website: "test.nl"
        profile.website.should === "http://www.test.nl"
      end
    end

    context "www website" do
      it "should add http protocol" do
        profile = create :profile, website: "www.test.nl"
        profile.website.should === "http://www.test.nl"
      end
    end

    context "correct website" do
      it "should add nothing" do
        profile = create :profile, website: "http://www.test.nl"
        profile.website.should === "http://www.test.nl"
      end
    end
  end

  describe "check twitter" do
    context "twitter without dollar sign" do
      it "should show twitter profile url" do
        profile = create :profile, twitter: "DutchAddick"
        profile.twitter.should === "DutchAddick"
      end
    end

    context "twitter with dollar sign" do
      it "should show twitter profile url" do
        profile = create :profile, twitter: "@DutchAddick"
        profile.twitter.should === "DutchAddick"
      end
    end
  end

end


