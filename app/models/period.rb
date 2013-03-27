class Period < ActiveRecord::Base
  has_many :gamerounds
  has_many :results, through: :gamerounds
  has_many :scores, through: :gamerounds
  has_many :jokers, through: :gamerounds

  attr_accessible :end_date, :period_nr, :start_date
  validates :end_date, :period_nr, :start_date, presence: true

  def full_name
    "#{period_nr}: #{start_date.strftime('%d-%m-%Y')} - #{end_date.strftime('%d-%m-%Y')}"
  end
end
