class Selection < ActiveRecord::Base
  belongs_to :user
  belongs_to :club

  attr_accessible :club_id, :user_id
  validates :club_id, :user_id, presence: true
end
