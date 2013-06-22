# == Schema Information
#
# Table name: newsitems
#
#  id         :integer          not null, primary key
#  title_nl   :string(255)
#  title_en   :string(255)
#  summary_nl :text
#  summary_en :text
#  content_nl :text
#  content_en :text
#  publish    :boolean
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sticky     :boolean
#  priority   :string(255)
#

require 'spec_helper'

describe Newsitem do
  it { should validate_presence_of :title_nl   }
  it { should validate_presence_of :title_en   }
  it { should validate_presence_of :summary_nl }
  it { should validate_presence_of :summary_en }
  it { should have_many(:comments) }
  it { should belong_to(:user) }
end
