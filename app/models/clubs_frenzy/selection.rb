class Selection < ActiveRecord::Base
  belongs_to :player
  belongs_to :club

  attr_accessible :club_id, :player_id
  validates :club_id, :player_id, presence: true

end
