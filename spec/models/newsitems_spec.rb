require 'spec_helper'

describe Newsitem do
  it { should validate_presence_of :title_nl   }
  it { should validate_presence_of :title_en   }
  it { should validate_presence_of :content_nl }
  it { should validate_presence_of :content_en }
  it { should have_many(:comments) }
end
