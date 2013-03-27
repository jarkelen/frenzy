class Setting < ActiveRecord::Base
  attr_accessible :curent_period, :max_teamsize, :max_teamvalue, :max_jokers, :participation
end
