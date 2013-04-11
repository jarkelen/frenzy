require 'spec_helper'

describe Newsitem do
  it { should validate_presence_of :title_nl   }
  it { should validate_presence_of :title_en   }
  it { should validate_presence_of :content_nl }
  it { should validate_presence_of :content_en }
  it { should validate_presence_of :publish }
  it { should have_many(:comments) }
  it { should belong_to(:user) }
end
