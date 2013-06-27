# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  base_nr            :integer
#  first_name         :string(255)
#  last_name          :string(255)
#  team_name          :string(255)
#  email              :string(255)      not null
#  language           :string(255)
#  role               :string(255)      default("user")
#  team_value         :integer          default(125)
#  assigned_jokers    :integer
#  encrypted_password :string(128)      not null
#  confirmation_token :string(128)
#  remember_token     :string(128)      not null
#  participation_due  :datetime
#  location           :string(255)
#  website            :string(255)
#  bio                :string(255)
#  facebook           :string(255)
#  twitter            :string(255)
#  favorite_club      :integer
#  birth_date         :datetime
#

class User < ActiveRecord::Base
  include Clearance::User

  has_many  :newsitems
  has_many  :players
  has_many  :games, through: :players
  has_many  :visits

  attr_accessor :random_nr

  attr_accessible :first_name, :last_name, :team_name, :email, :role, :language, :password,
                  :location, :website, :bio, :facebook, :twitter, :favorite_club, :birth_date, :base_nr, :random_nr

  before_save { |user| user.email = email.downcase }
  before_save :check_protocol
  before_save :check_twitter
  before_create :assign_base_nr

  after_create :create_player

  validates :role, :language, :team_value, :email, presence: true
  validates :password, presence: true, on: :create
  validates :first_name, :last_name, :team_name, length: { maximum: 50 }
  validates :bio, length: { maximum: 140 }
  validates :facebook, :twitter, :favorite_club, :location, length: { maximum: 50 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]\z/i
  #validates :email, format: { with: email_regex }, uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }, on: :create

  scope :admins, where(role: 'admin')

  #--------------------------------------------------------------------------------------------

  def admin?
    return true if role == "admin"
  end

  def full_name
    [first_name, last_name].join(' ').squeeze(' ')
  end

  def create_player
    Player.create(user_id: self.id, game_id: Game.default_game.id)
  end

  def assign_base_nr
    max_user = User.order("base_nr ASC").last
    if max_user.blank?
      self.base_nr = 1
    else
      self.base_nr = max_user.base_nr + 1
    end
  end

  def check_protocol
    unless self.website.blank?
      unless self.website[/^http:\/\//] || self.website[/^https:\/\//]
        unless self.website.index('www')
          self.website = "http://www.#{website}"
        else
          self.website = "http://#{website}"
        end
      end
    end
  end

  def check_twitter
    unless self.twitter.blank?
      if self.twitter.index('@')
        self.twitter = self.twitter.split('@')[1]
      end
    end
  end

end
