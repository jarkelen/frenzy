# == Schema Information
#
# Table name: scores
#
#  id           :integer          not null, primary key
#  score        :integer
#  gameround_id :integer
#  club_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Score do
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :club_id      }
  it { should validate_presence_of :score        }
  it { should belong_to(:club)      }
  it { should belong_to(:gameround) }
end
