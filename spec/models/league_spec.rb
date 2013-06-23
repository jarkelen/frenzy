# == Schema Information
#
# Table name: leagues
#
#  id           :integer          not null, primary key
#  league_name  :string(255)
#  league_short :string(255)
#  level        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe League do
  it { should validate_presence_of :league_name   }
  it { should validate_presence_of :league_short  }
  it { should validate_presence_of :level         }
  it { should have_many(:clubs) }

end
