require 'spec_helper'

describe Ranking do
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :player_id      }
  it { should validate_presence_of :total_score  }
  it { should belong_to(:user)      }
  it { should belong_to(:gameround) }

  describe "calculate_ranking" do
    it "should rank highest user as first" do
      FactoryGirl.create :setting
      FactoryGirl.create_list :period, 4
      @player_top    = FactoryGirl.create(:player)
      @player_bottom = FactoryGirl.create(:player)
      @player_top_ranking1    = FactoryGirl.create(:ranking, player: @player_top, total_score: 10)
      @player_top_ranking2    = FactoryGirl.create(:ranking, player: @player_top, total_score: 5)
      @player_bottom_ranking1 = FactoryGirl.create(:ranking, player: @player_bottom, total_score: 2)
      @player_bottom_ranking2 = FactoryGirl.create(:ranking, player: @player_bottom, total_score: 6)

      Ranking.calculate_ranking('general').should =~ [[@player_top, 15], [@player_bottom, 8]]
    end
  end
end