require 'spec_helper'

describe Newsitem do
  it { should validate_presence_of :title_nl   }
  it { should validate_presence_of :title_en   }
  it { should validate_presence_of :summary_nl }
  it { should validate_presence_of :summary_en }
  it { should have_many(:comments) }
  it { should belong_to(:user) }
end
