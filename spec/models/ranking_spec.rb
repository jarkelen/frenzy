# == Schema Information
#
# Table name: rankings
#
#  id           :integer          not null, primary key
#  total_score  :integer
#  gameround_id :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  player_id    :integer
#

require 'spec_helper'

describe Ranking do
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :player_id      }
  it { should validate_presence_of :total_score  }
  it { should belong_to(:player)      }
  it { should belong_to(:gameround) }

  describe "calculate_ranking" do
    let!(:setting)                { create(:setting) }
    let!(:period)                 { create_list(:period, 4) }
    let!(:user)                   { create(:user) }
    let!(:game)                   { create(:game) }
    let!(:player_top)             { create(:player, user: user, game: game) }
    let!(:player_bottom)          { create(:player, user: user, game: game) }
    let!(:gameround1)             { create(:gameround) }
    let!(:gameround2)             { create(:gameround) }
    let!(:player_top_ranking1)    { create(:ranking, player: player_top, gameround: gameround1, total_score: 10) }
    let!(:player_top_ranking2)    { create(:ranking, player: player_top, gameround: gameround2, total_score: 5) }
    let!(:player_bottom_ranking1) { create(:ranking, player: player_bottom, gameround: gameround1, total_score: 2) }
    let!(:player_bottom_ranking2) { create(:ranking, player: player_bottom, gameround: gameround2, total_score: 6) }

    it "should rank highest user as first" do
      Ranking.calculate_ranking('general').should =~ [[player_top, 15], [player_bottom, 8]]
    end
  end
end
