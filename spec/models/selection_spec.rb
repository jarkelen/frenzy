require 'spec_helper'

describe Selection do
  it { should validate_presence_of :player_id }
  it { should validate_presence_of :club_id }
  it { should belong_to(:club) }
  it { should belong_to(:player) }
end
