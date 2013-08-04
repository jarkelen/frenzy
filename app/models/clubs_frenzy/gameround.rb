# == Schema Information
#
# Table name: gamerounds
#
#  id         :integer          not null, primary key
#  number     :integer
#  start_date :datetime
#  end_date   :datetime
#  processed  :boolean
#  period_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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

  scope :active, where("start_date >= ?", DateTime.now.to_date)
  scope :processed, where(processed: true)
  scope :not_processed, where(processed: false)
  scope :next, where(processed: false).limit(1)
end
