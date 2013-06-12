require 'spec_helper'

describe Prize do
  it { should validate_presence_of :name }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :value   }
  it { should belong_to(:user) }
end
