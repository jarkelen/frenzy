class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true

  attr_accessible :content
  validates :commentable_id, :commentable_type, :content, presence: true
end
