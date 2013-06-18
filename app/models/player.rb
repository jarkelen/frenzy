class Player < ActiveRecord::Base
  has_many  :selections, dependent: :destroy
  has_many  :jokers, dependent: :destroy
  has_many  :rankings, dependent: :destroy
  has_many  :clubs, through: :selections
  has_many  :scores, through: :clubs
  belongs_to :user
  belongs_to :game
  attr_accessible :cups, :medals, :rosettes, :user_id, :game_id
end
