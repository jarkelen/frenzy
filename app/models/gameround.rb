class Gameround < ActiveRecord::Base
  belongs_to :period
  has_many :results, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :jokers, dependent: :destroy
  has_many :rankings, dependent: :destroy
  accepts_nested_attributes_for :jokers
  accepts_nested_attributes_for :results

  attr_accessible :end_date, :number, :period_id, :processed, :start_date, :jokers_attributes, :results_attributes
  validates :end_date, :number, :period_id, :start_date, presence: true

  scope :active, where(processed: false)
  scope :current, where(processed: true)
  scope :next, where(processed: false).limit(1)
end
