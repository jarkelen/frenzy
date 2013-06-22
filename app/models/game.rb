# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Game < ActiveRecord::Base
  has_many :players
  attr_accessible :name
  validates :name, presence: true

  def self.default_game
    Game.where(name: "Clubs Frenzy").first
  end


end
