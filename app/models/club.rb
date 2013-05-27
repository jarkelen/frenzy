class Club < ActiveRecord::Base
  belongs_to :league
  has_many :home_results, class_name: 'Result', foreign_key: 'home_club_id'
  has_many :away_results, class_name: 'Result', foreign_key: 'away_club_id'
  has_many :scores
  has_many :selections
  has_many :jokers

  attr_accessible :club_name, :league_id, :period1, :period2, :period3, :period4
  validates :club_name, :league_id, :period1, :period2, :period3, :period4, presence: true

  scope :own, ->(user) {
    joins("INNER JOIN selections ON selections.club_id = clubs.id").
    where("selections.club_id = clubs.id AND selections.user_id = #{user.id}").
    select("clubs.*")
  }

  scope :selectable, ->(current_user, current_teamvalue) {
    joins('LEFT OUTER JOIN selections ON selections.club_id = clubs.id').
    where('selections.club_id IS null').
    where("period#{Setting.first.current_period} <= ?", (current_user.team_value-current_teamvalue)).order("period#{Setting.first.current_period} DESC")
  }


end
