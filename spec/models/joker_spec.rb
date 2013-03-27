require 'spec_helper'

describe Joker do
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :user_id      }
  it { should validate_presence_of :club_id      }
  it { should belong_to(:gameround) }
  it { should belong_to(:user)      }
  it { should belong_to(:club)      }
end
