class Ranking < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :user

  attr_accessible :gameround_id, :total_score, :user_id
  validates       :gameround_id, :total_score, :user_id, presence: true

  scope :current_gameround, where(gameround_id: Gameround.current.last).order('total_score DESC')

  def self.calculate_ranking(type)
    found_rankings = []
    users = User.all
    users.each do |user|
      user_score = 0

      if type == "general"
        rankings = user.rankings
      else
        settings = Setting.first
        period_gamerounds = Gameround.where(period_id: settings.current_period)
        rankings = user.rankings.find_all_by_gameround_id(period_gamerounds)
      end

      rankings.each do |ranking|
        user_score += ranking.total_score
      end
      found_rankings << [user, user_score]
    end
    found_rankings.sort {|a,b| b[1] <=> a[1]}
  end

end
