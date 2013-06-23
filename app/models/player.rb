# == Schema Information
#
# Table name: players
#
#  id                :integer          not null, primary key
#  rosettes          :integer          default(0)
#  medals            :integer          default(0)
#  cups              :integer          default(0)
#  user_id           :integer
#  game_id           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  team_value        :integer          default(125)
#  assigned_jokers   :integer
#  participation_due :datetime
#

class Player < ActiveRecord::Base
  has_many  :selections, dependent: :destroy
  has_many  :jokers, dependent: :destroy
  has_many  :rankings, dependent: :destroy
  has_many  :clubs, through: :selections
  has_many  :scores, through: :clubs
  belongs_to :user
  belongs_to :game

  attr_accessible :cups, :medals, :rosettes, :user_id, :game_id, :participation_due, :team_value, :assigned_jokers

  before_create :assign_jokers
  before_create :set_participation_due

  def self.of_frenzy(user, game_name="Clubs Frenzy")
    frenzy_game = Game.where(name: game_name).first
    Player.where(game_id: frenzy_game.id, user_id: user.id).first
  end

  def set_participation_due
    settings = Setting.first
    unless settings.participation
      self.participation_due = 3.days.from_now
    end
  end

  def participation_restricted?(team_size, team_value)
    settings = Setting.first
    return true unless team_size.to_i < settings.max_teamsize.to_i
    return true unless team_value.to_i < settings.max_teamvalue.to_i

    if self.participation_due == nil
      return true unless settings.participation
    else
      return true unless DateTime.now < self.participation_due
    end
    return false
  end

  def assign_jokers
    periods = Period.all.size
    settings = Setting.first

    jokers_per_period = settings.max_jokers / periods
    self.assigned_jokers = ((periods + 1) - settings.current_period) * jokers_per_period
  end
end
