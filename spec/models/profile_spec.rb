require 'spec_helper'

describe Profile do
  it { should validate_presence_of :user_id }
  it { should belong_to(:user) }

  describe "check protocol" do
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

end
