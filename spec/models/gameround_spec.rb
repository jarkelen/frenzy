# == Schema Information
#
# Table name: gamerounds
#
#  id         :integer          not null, primary key
#  number     :integer
#  start_date :datetime
#  end_date   :datetime
#  processed  :boolean
#  period_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Gameround do
  it { should validate_presence_of :end_date   }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :number     }
  it { should validate_presence_of :period_id  }
  it { should have_many(:results)  }
  it { should have_many(:scores)   }
  it { should have_many(:jokers)   }
  it { should have_many(:rankings) }
  it { should belong_to(:period) }
end
