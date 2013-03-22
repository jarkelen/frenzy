class Ranking < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :user

  attr_accessible :gameround_id, :total_score, :user_id
  validates       :gameround_id, :total_score, :user_id, presence: true
end
