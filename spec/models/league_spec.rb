require 'spec_helper'

describe League do
  it { should validate_presence_of :league_name   }
  it { should validate_presence_of :league_short  }
  it { should validate_presence_of :level         }
  #it { should have_many(:dossiers).through(:care_periods)  }
  #it { should belong_to :parent }

end
