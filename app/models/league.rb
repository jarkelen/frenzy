class League < ActiveRecord::Base
  has_many :clubs

  attr_accessible :league_name, :league_short, :level
  validates :league_name, :league_short, :level, presence: true
end
