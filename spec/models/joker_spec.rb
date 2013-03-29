require 'spec_helper'

describe Joker do
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :user_id      }
  it { should validate_presence_of :club_id      }
  it { should belong_to(:gameround) }
  it { should belong_to(:user)      }
  it { should belong_to(:club)      }

  describe ".validate_jokers" do
    before :each do
      @gameround = FactoryGirl.create(:gameround)
      @club1 = FactoryGirl.create(:club)
      @club2 = FactoryGirl.create(:club)
      @club3 = FactoryGirl.create(:club)
    end

    it "should be successful with valid parameters" do
      Joker.validate_jokers(@gameround, @club1, @club2, @club3).should be_true
    end

    it "should include a gameround" do
      Joker.validate_jokers(nil, @club1, @club2, @club3).should be_false
    end

    it "should fail when first 2 clubs are equal" do
      Joker.validate_jokers(@gameround, @club1, @club1, @club3).should be_false
    end

    it "should fail when last 2 clubs are equal" do
      Joker.validate_jokers(@gameround, @club1, @club2, @club2).should be_false
    end

    it "should fail when first and last clubs are equal" do
      Joker.validate_jokers(@gameround, @club1, @club2, @club1).should be_false
    end
  end
end
