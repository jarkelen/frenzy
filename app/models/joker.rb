class Joker < ActiveRecord::Base
  belongs_to :gameround
  belongs_to :user
  belongs_to :club

  attr_accessible :gameround_id, :user_id, :club_id
  validates :gameround_id, :user_id, :club_id, presence: true

  def self.validate_jokers(gameround, club1, club2, club3)
    return false if gameround.blank?
    return false if club1 == club2 unless club2.blank?
    return false if club1 == club3 unless club3.blank?
    return false if club2 == club3 unless club3.blank?
    return true
  end
end
