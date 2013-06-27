# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  visit_nr   :integer
#  visit_date :datetime
#  league     :string(255)
#  home_club  :string(255)
#  away_club  :string(255)
#  ground     :string(255)
#  street     :string(255)
#  city       :string(255)
#  country    :string(255)
#  longitude  :float
#  latitude   :float
#  gmaps      :boolean
#  result     :string(255)
#  season     :string(255)
#  kickoff    :string(255)
#  gate       :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Visit do
  it { should belong_to(:user) }

  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:street) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:ground) }
  it { should validate_presence_of(:result) }
  it { should validate_presence_of(:visit_nr) }
end
