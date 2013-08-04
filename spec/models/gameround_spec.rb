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

  describe "scopes" do
    let!(:gameround1) { create :gameround, processed: false, start_date: 5.days.from_now }
    let!(:gameround2) { create :gameround, processed: true }
    let!(:gameround3) { create :gameround, processed: false }

    describe "active" do
      it "includes unprocessed gamerounds" do
        Gameround.active.should include(gameround1)
      end

      it "omits processed gamerounds" do
        Gameround.active.should_not include(gameround2)
      end
    end

    describe "processed" do
      it "omits unprocessed gamerounds" do
        Gameround.processed.should_not include(gameround1)
      end

      it "includes processed gamerounds" do
        Gameround.processed.should include(gameround2)
      end
    end
  end
end
