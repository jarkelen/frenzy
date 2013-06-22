# == Schema Information
#
# Table name: selections
#
#  id         :integer          not null, primary key
#  club_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  player_id  :integer
#

class Selection < ActiveRecord::Base
  belongs_to :player
  belongs_to :club

  attr_accessible :club_id, :player_id
  validates :club_id, :player_id, presence: true

end
