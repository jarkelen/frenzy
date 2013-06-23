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

class Newsitem < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable

  attr_accessible :content_en, :content_nl, :summary_nl, :summary_en, :title_en, :title_nl, :publish, :user_id, :sticky, :priority
  validates :summary_nl, :summary_en, :title_en, :title_nl, :user_id, presence: true

  scope :newest_first, order('created_at DESC')
  scope :top3, where(publish: true, sticky: false).order('created_at DESC').limit(3)
  scope :published, where(publish: true)
  scope :sticky, where(publish: true, sticky: true)
end
