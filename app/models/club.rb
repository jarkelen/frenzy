class Club < ActiveRecord::Base
  belongs_to :league
  #has_many :results_as_home
  #has_many :results_as_away
  #has_many scores
  has_many selections

  attr_accessible :club_name, :league_id, :period1, :period2, :period3, :period4
  validates :club_name, :league_id, :period1, :period2, :period3, :period4, presence: true
end
