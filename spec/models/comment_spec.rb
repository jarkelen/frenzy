require 'spec_helper'

describe Comment do
  it { should validate_presence_of :commentable_id   }
  it { should validate_presence_of :commentable_type }
  it { should validate_presence_of :content          }
  it { should belong_to(:commentable) }
end
