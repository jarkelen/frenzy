require 'spec_helper'

describe Ranking do
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :user_id      }
  it { should validate_presence_of :total_score  }
  it { should belong_to(:user)      }
  it { should belong_to(:gameround) }

  describe "calculate_ranking" do
    before :each do
      FactoryGirl.create :setting
      FactoryGirl.create_list :period, 4
      @user_top    = FactoryGirl.create(:user)
      @user_bottom = FactoryGirl.create(:user)
      @user_top_ranking1    = FactoryGirl.create(:ranking, user: @user_top, total_score: 10)
      @user_top_ranking2    = FactoryGirl.create(:ranking, user: @user_top, total_score: 5)
      @user_bottom_ranking1 = FactoryGirl.create(:ranking, user: @user_bottom, total_score: 2)
      @user_bottom_ranking2 = FactoryGirl.create(:ranking, user: @user_bottom, total_score: 6)
    end

    it "should rank highest user as first" do
      #Ranking.calculate_ranking('general').should =~ [[@user_top, 15], [@user_bottom, 8]]
    end
  end
end