# == Schema Information
#
# Table name: scores
#
#  id           :integer          not null, primary key
#  score        :integer
#  gameround_id :integer
#  club_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Score < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :club

  attr_accessible :club_id, :gameround_id, :score
  validates :club_id, :gameround_id, :score, presence: true
end
