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
    return false if self.joker_found(gameround, club1)
    return false if self.joker_found(gameround, club2)
    return false if self.joker_found(gameround, club3)
    return true
  end

  def self.joker_found(gameround, club)
    joker = self.where(club_id: club, gameround_id: gameround)
    return false if joker.blank?
    return true
  end

  def self.jokered?(gameround, user, club)
    joker = self.where(club_id: club, gameround_id: gameround, user_id: user)
    return false if joker.blank?
    return true
  end

  def effective?(gameround)
    if gameround.processed
      score = self.club.scores.where(gameround_id: gameround).pluck(:score).first
      if score
        if score*2 > score
          "success"
        elsif score*2 < score
          "important"
        else
          "neutral"
        end
      else
        "neutral"
      end
    else
      "neutral"
    end
  end

end
