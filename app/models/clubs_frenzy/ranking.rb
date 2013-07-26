# == Schema Information
#
# Table name: rankings
#
#  id           :integer          not null, primary key
#  total_score  :integer
#  gameround_id :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  player_id    :integer
#

class Ranking < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :player

  attr_accessible :gameround_id, :total_score, :player_id
  validates       :gameround_id, :total_score, :player_id, presence: true

  scope :current_gameround, where(gameround_id: Gameround.processed.last).order('total_score DESC')

end
