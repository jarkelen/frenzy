require 'spec_helper'

describe Selection do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :club_id }
  it { should belong_to(:club) }
  it { should belong_to(:user) }
end
