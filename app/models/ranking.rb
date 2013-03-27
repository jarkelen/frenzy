class Ranking < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :user

  attr_accessible :gameround_id, :total_score, :user_id
  validates       :gameround_id, :total_score, :user_id, presence: true

  scope :current_gameround, where(gameround_id: Gameround.current.last).order('total_score DESC')

  def self.calculate_overall_ranking
    overall_rankings = []
    users = User.all
    users.each do |user|
      user_score = 0
      rankings = user.rankings
      rankings.each do |ranking|
        user_score += ranking.total_score
      end
      overall_rankings << [user, user_score]
    end
    overall_rankings.sort {|a,b| b[1] <=> a[1]}
  end
end
