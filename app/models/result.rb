class Result < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :club

  attr_accessible :club_away_id, :club_home_id, :gameround_id, :score_away, :score_home
  validates :club_away_id, :club_home_id, :gameround_id, :score_away, :score_home, presence: true

end
