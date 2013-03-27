require 'spec_helper'

describe Club do
  it { should validate_presence_of :club_name }
  it { should validate_presence_of :league_id }
  it { should validate_presence_of :period1   }
  it { should validate_presence_of :period2   }
  it { should validate_presence_of :period3   }
  it { should validate_presence_of :period4   }
  it { should have_many(:scores) }
  it { should have_many(:selections) }
  it { should have_many(:jokers) }
  it { should belong_to(:league) }

end
