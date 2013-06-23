# == Schema Information
#
# Table name: settings
#
#  id             :integer          not null, primary key
#  current_period :integer
#  max_teamsize   :integer
#  max_jokers     :integer
#  participation  :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  max_teamvalue  :integer
#

class Setting < ActiveRecord::Base
  attr_accessible :current_period, :max_teamsize, :max_teamvalue, :max_jokers, :participation
end
