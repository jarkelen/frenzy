class Club < ActiveRecord::Base
  belongs_to :league
  has_many :results_as_home, class_name: 'Result', foreign_key: 'result_id'
  has_many :results_as_away, class_name: 'Result', foreign_key: 'result_id'
  has_many :scores
  has_many :selections

  attr_accessible :club_name, :league_id, :period1, :period2, :period3, :period4
  validates :club_name, :league_id, :period1, :period2, :period3, :period4, presence: true
end
