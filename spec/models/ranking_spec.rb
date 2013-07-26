# == Schema Information
#
# Table name: rankings
#
#  id           :integer          not null, primary key
#  total_score  :integer
#  gameround_id :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  player_id    :integer
#

require 'spec_helper'

describe Ranking do
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :player_id      }
  it { should validate_presence_of :total_score  }
  it { should belong_to(:player)      }
  it { should belong_to(:gameround) }

end
