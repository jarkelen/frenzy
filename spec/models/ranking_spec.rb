require 'spec_helper'

describe Ranking do
  it { should validate_presence_of :gameround_id }
  it { should validate_presence_of :user_id      }
  it { should validate_presence_of :total_score  }
  it { should belong_to(:user)      }
  it { should belong_to(:gameround) }
end
