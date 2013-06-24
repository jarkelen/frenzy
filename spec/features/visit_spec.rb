require 'spec_helper'

describe Visit do
  it { should belong_to(:club) }

  it { should validate_presence_of(:visit_date) }
  it { should validate_presence_of(:club_away) }

end