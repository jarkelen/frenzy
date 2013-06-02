class User < ActiveRecord::Base
  include Clearance::User

=begin
    add_column :users, :location, :string
    add_column :users, :website, :string
    add_column :users, :bio, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :favorite_club, :string
    add_column :users, :favorite_english_club, :integer
=end

  has_many  :selections, dependent: :destroy
  has_many  :jokers, dependent: :destroy
  has_many  :rankings, dependent: :destroy
  has_many  :clubs, through: :selections
  has_many  :scores, through: :clubs
  has_many  :newsitems

  attr_accessible :first_name, :last_name, :team_name, :email, :role, :language, :team_value, :participation_due, :password,
                  :location, :website, :bio, :facebook, :twitter, :favorite_club, :favorite_english_club

  before_create :assign_jokers
  before_create :set_participation_due
  before_save { |user| user.email = email.downcase }
  before_update :check_protocol
  before_update :check_twitter

  validates :first_name, :last_name, :team_name, :role, :language, :team_value, :email, presence: true
  validates :password, presence: true, on: :create
  validates :first_name, :last_name, :team_name, length: { maximum: 50 }
  validates :bio, length: { maximum: 140 }
  validates :facebook, :twitter, :favorite_club, :location, length: { maximum: 50 }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
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

  def assign_jokers
    periods = Period.all.size
    settings = Setting.first

    jokers_per_period = settings.max_jokers / periods
    self.assigned_jokers = ((periods + 1) - settings.current_period) * jokers_per_period
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

  def check_protocol
    unless self.website.blank?
      unless self.website.index('www')
        self.website = "www.#{website}"

        unless self.website[/^http:\/\//] || self.website[/^https:\/\//]
          self.website = "http://#{website}"
        end
      end

      unless self.website[/^http:\/\//] || self.website[/^https:\/\//]
        self.website = "http://#{website}"
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
