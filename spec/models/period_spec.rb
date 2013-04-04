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
end
