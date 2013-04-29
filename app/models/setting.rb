class Setting < ActiveRecord::Base
  attr_accessible :current_period, :max_teamsize, :max_jokers, :participation
end
