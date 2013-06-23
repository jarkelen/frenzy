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

require 'spec_helper'

describe Selection do
  it { should validate_presence_of :player_id }
  it { should validate_presence_of :club_id }
  it { should belong_to(:club) }
  it { should belong_to(:player) }
end
