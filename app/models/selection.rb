class Selection < ActiveRecord::Base
  belongs_to :user
  belongs_to :club

  attr_accessible :club_id, :user_id
  validates :club_id, :user_id, presence: true
=begin
  scope :high_to_low, {
    joins("INNER JOIN clubs ON clubs.id = selections.club_id").
    order("clubs.league_id ASC").
    select('selections.*')
  }
=end
end
