require 'spec_helper'

describe User do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name  }
  it { should validate_presence_of :team_name  }
  it { should validate_presence_of :role       }
  it { should validate_presence_of :language   }
  #it { should have_many(:jokers)     }
  #it { should have_many(:rankings)   }
  #it { should have_many(:selections) }
  #it { should have_many(:clubs).through(:selections) }

end
