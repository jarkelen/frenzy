class Joker < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :user
  belongs_to :club

  attr_accessible :gameround_id, :user_id, :club_id
  validates :gameround_id, :user_id, :club_id, presence: true
end
