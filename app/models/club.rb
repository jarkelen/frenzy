class Club < ActiveRecord::Base
  belongs_to :league
  has_many :home_results, class_name: 'Result', foreign_key: 'home_club_id'
  has_many :away_results, class_name: 'Result', foreign_key: 'away_club_id'
  has_many :scores
  has_many :selections
  has_many :jokers

  attr_accessible :club_name, :league_id, :period1, :period2, :period3, :period4
  validates :club_name, :league_id, :period1, :period2, :period3, :period4, presence: true

  scope :by_name, order("club_name ASC")

  scope :own, ->(player) {
    joins("INNER JOIN selections ON selections.club_id = clubs.id").
    where("selections.club_id = clubs.id AND selections.player_id = #{player.id}").
    select("clubs.*")
  }

  scope :selectable, ->(current_player, current_teamvalue) {
    joins('LEFT OUTER JOIN selections ON selections.club_id = clubs.id').
    where('selections.player_id IS NULL OR selections.player_id != ?', current_player.id).
    where("clubs.period#{Setting.first.current_period} <= ?", (current_player.user.team_value-current_teamvalue)).order("clubs.period#{Setting.first.current_period} DESC")
  }


end
