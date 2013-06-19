class Game < ActiveRecord::Base
  has_many :players
  attr_accessible :name
  validates :name, presence: true

  def self.default_game
    Game.where(name: "Clubs Frenzy").first
  end


end
