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