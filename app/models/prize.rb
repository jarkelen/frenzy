class Prize < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :user_id, :value
  validates :user_id, :name, :value, presence: true
end
