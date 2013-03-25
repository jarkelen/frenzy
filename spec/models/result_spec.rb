require 'spec_helper'

describe Result do
  it { should validate_presence_of :home_club_id }
  it { should validate_presence_of :away_club_id }
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :home_score   }
  it { should validate_presence_of :away_score   }
end