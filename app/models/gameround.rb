class Gameround < ActiveRecord::Base
  belongs_to :period
  has_many :results
  has_many :scores
  has_many :jokers
  has_many :rankings

  attr_accessible :end_date, :number, :period_id, :processed, :start_date
  validates :end_date, :number, :period_id, :start_date, presence: true

  scope :active, where('end_date > ?', Date.today)

end
