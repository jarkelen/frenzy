class League < ActiveRecord::Base
  attr_accessible :league_name, :league_short, :level
  validates :league_name, :league_short, :level, presence: true
end
