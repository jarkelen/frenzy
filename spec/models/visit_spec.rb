# == Schema Information
#
# Table name: visits
#
#  id           :integer          not null, primary key
#  visit_nr     :integer
#  visit_date   :datetime
#  league_id    :integer
#  home_club_id :string(255)
#  integer      :string(255)
#  away_club_id :integer
#  ground       :string(255)
#  street       :string(255)
#  city         :string(255)
#  longitude    :float
#  latitude     :float
#  result       :string(255)
#  season       :string(255)
#  kickoff      :string(255)
#  gate         :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Visit do
  pending "add some examples to (or delete) #{__FILE__}"
end
