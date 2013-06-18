require 'spec_helper'

describe Player do
  it { should have_many(:jokers)     }
  it { should have_many(:rankings)   }
  it { should have_many(:selections) }
  it { should have_many(:clubs).through(:selections) }
  it { should belong_to(:user) }
  it { should belong_to(:match) }
end
