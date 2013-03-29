class Gameround < ActiveRecord::Base
  belongs_to :period
  has_many :results
  has_many :scores
  has_many :jokers
  has_many :rankings
  accepts_nested_attributes_for :jokers

  attr_accessible :end_date, :number, :period_id, :processed, :start_date, :jokers_attributes
  validates :end_date, :number, :period_id, :start_date, presence: true

  scope :active, where(processed: false)
  scope :current, where(processed: true)

end
