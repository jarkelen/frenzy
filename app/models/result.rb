class Result < ActiveRecord::Base
  attr_accessible :club_away_id, :club_home_id, :gameround_id, :score_away, :score_hoem
end
