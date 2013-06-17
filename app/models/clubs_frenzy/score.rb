class Score < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :club

  attr_accessible :club_id, :gameround_id, :score
  validates :club_id, :gameround_id, :score, presence: true
end
