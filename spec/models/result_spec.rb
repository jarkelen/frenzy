# == Schema Information
#
# Table name: results
#
#  id           :integer          not null, primary key
#  home_club_id :integer
#  away_club_id :integer
#  home_score   :integer
#  away_score   :integer
#  gameround_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Result do
  it { should validate_presence_of :home_club_id }
  it { should validate_presence_of :away_club_id }
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :home_score   }
  it { should validate_presence_of :away_score   }
end
