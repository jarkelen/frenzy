class Newsitem < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable

  attr_accessible :content_en, :content_nl, :title_en, :title_nl, :publish, :user_id
  validates :content_en, :content_nl, :title_en, :title_nl, :publish, :user_id, presence: true

  scope :newest_first, where(publish: true).order('created_at DESC')
  scope :top3, where(publish: true).order('created_at DESC').limit(3)
end