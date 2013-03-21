class User < ActiveRecord::Base
  include Clearance::User

  has_many :selections

  #has_many :jokers
  #has_many :rankings
  #has_many :clubs, through: :selections

  attr_accessible :first_name, :last_name, :team_name, :email, :role, :language

  before_save { |user| user.email = email.downcase }

  validates :first_name, :last_name, :team_name, :role, :language, presence: true
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: email_regex },
                    uniqueness: { case_sensitive: false }

end
