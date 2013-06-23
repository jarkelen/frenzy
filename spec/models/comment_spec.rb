# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  content          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'spec_helper'

describe Comment do
  it { should validate_presence_of :commentable_id   }
  it { should validate_presence_of :commentable_type }
  it { should validate_presence_of :content          }
  it { should belong_to(:commentable) }
end
