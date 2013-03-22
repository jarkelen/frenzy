require 'spec_helper'

describe Result do
  it { should validate_presence_of :club_away_id }
  it { should validate_presence_of :club_home_id }
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :score_away   }
  it { should validate_presence_of :score_home   }
end