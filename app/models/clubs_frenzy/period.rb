# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  period_nr  :integer
#  start_date :datetime
#  end_date   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)
#

class Period < ActiveRecord::Base
  has_many :gamerounds
  has_many :results, through: :gamerounds
  has_many :scores, through: :gamerounds
  has_many :jokers, through: :gamerounds

  attr_accessible :end_date, :period_nr, :start_date, :name
  validates :end_date, :period_nr, :start_date, :name, presence: true

  def full_name
    "#{period_nr}: #{start_date.strftime('%d-%m-%Y')} - #{end_date.strftime('%d-%m-%Y')}"
  end
end
