class Period < ActiveRecord::Base
  has_many :gamerounds
  has_many :results, through: :gamerounds
  has_many :scores, through: :gamerounds
  has_many :jokers, through: :gamerounds

  attr_accessible :end_date, :period_name, :period_nr, :start_date
  validates :end_date, :period_name, :period_nr, :start_date, presence: true
end
