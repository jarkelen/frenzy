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

class Ranking < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :player

  attr_accessible :gameround_id, :total_score, :player_id
  validates       :gameround_id, :total_score, :player_id, presence: true

  scope :current_gameround, where(gameround_id: Gameround.processed.last).order('total_score DESC')

  def self.calculate_ranking(type)
    found_rankings = []
    players = Player.all
    players.each do |player|
      player_score = 0

      if type == "general"
        rankings = player.rankings
      else
        settings = Setting.first
        period_gamerounds = Gameround.where(period_id: settings.current_period)
        rankings = player.rankings.find_all_by_gameround_id(period_gamerounds)
      end

      rankings.each do |ranking|
        player_score += ranking.total_score
      end
      found_rankings << [player, player_score]
    end
    found_rankings.sort {|a,b| b[1] <=> a[1]}
  end

end
