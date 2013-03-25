class Result < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :home_club, class_name: 'Club'
  belongs_to :away_club, class_name: 'Club'

  attr_accessible :away_club_id, :home_club_id, :gameround_id, :home_score, :away_score
  validates :away_club_id, :home_club_id, :gameround_id, :home_score, :away_score, presence: true

end
