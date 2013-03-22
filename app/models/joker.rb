class Joker < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :user

  attr_accessible :gameround_id, :user_id
  validates :gameround_id, :user_id, presence: true
end
