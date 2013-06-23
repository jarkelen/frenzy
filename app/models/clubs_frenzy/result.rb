# == Schema Information
#
# Table name: results
#
#  id           :integer          not null, primary key
#  home_club_id :integer
#  away_club_id :integer
#  home_score   :integer
#  away_score   :integer
#  gameround_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Result < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :home_club, class_name: 'Club'
  belongs_to :away_club, class_name: 'Club'

  attr_accessible :away_club_id, :home_club_id, :gameround_id, :home_score, :away_score
  validates :away_club_id, :home_club_id, :gameround_id, :home_score, :away_score, presence: true

end
