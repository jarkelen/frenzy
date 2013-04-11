class Newsitem < ActiveRecord::Base
  has_many :comments, as: :commentable

  attr_accessible :content_en, :content_nl, :title_en, :title_nl
  validates :content_en, :content_nl, :title_en, :title_nl, presence: true
end
