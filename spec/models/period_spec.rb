# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  period_nr  :integer
#  start_date :datetime
#  end_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

require 'spec_helper'

describe Period do
  it { should validate_presence_of :end_date    }
  it { should validate_presence_of :start_date  }
  it { should validate_presence_of :period_nr   }
  it { should validate_presence_of :name   }
  it { should have_many(:gamerounds) }
  it { should have_many(:results).through(:gamerounds) }
  it { should have_many(:jokers).through(:gamerounds)  }
  it { should have_many(:scores).through(:gamerounds)  }

  it "should format the period full name" do
    period = FactoryGirl.create :period, period_nr: 1, start_date: 1.day.from_now, end_date: 1.month.from_now
    period.full_name.should === "1: #{1.day.from_now.strftime('%d-%m-%Y')} - #{1.month.from_now.strftime('%d-%m-%Y')}"
  end
end
