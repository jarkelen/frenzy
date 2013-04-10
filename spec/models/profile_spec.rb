require 'spec_helper'

describe Profile do
  it { should validate_presence_of :user_id }
  it { should belong_to(:user) }
end
