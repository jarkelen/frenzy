# == Schema Information
#
# Table name: leagues
#
#  id           :integer          not null, primary key
#  league_name  :string(255)
#  league_short :string(255)
#  level        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class League < ActiveRecord::Base
  has_many :clubs

  attr_accessible :league_name, :league_short, :level
  validates :league_name, :league_short, :level, presence: true
end
