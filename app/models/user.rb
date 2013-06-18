class User < ActiveRecord::Base
  include Clearance::User

  has_many  :newsitems
  has_many  :players
  has_many  :games, through: :players

  attr_accessible :first_name, :last_name, :team_name, :email, :role, :language, :password,
                  :location, :website, :bio, :facebook, :twitter, :favorite_club, :birth_date

  before_save { |user| user.email = email.downcase }
  before_save :check_protocol
  before_save :check_twitter

  validates :first_name, :last_name, :team_name, :role, :language, :team_value, :email, presence: true
  validates :password, presence: true, on: :create
  validates :first_name, :last_name, :team_name, length: { maximum: 50 }
  validates :bio, length: { maximum: 140 }
  validates :facebook, :twitter, :favorite_club, :location, length: { maximum: 50 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]\z/i
  validates :email, format: { with: email_regex }, uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6 }, on: :create

  scope :admins, where(role: 'admin')

  #--------------------------------------------------------------------------------------------

  def admin?
    return true if role == "admin"
  end

  def full_name
    [first_name, last_name].join(' ').squeeze(' ')
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
