class User < ActiveRecord::Base
  include Clearance::User

  has_many  :selections, dependent: :destroy
  has_many  :jokers, dependent: :destroy
  has_many  :rankings, dependent: :destroy
  has_many  :clubs, through: :selections
  has_one   :profile, dependent: :destroy
  has_many  :newsitems

  attr_accessible :first_name, :last_name, :team_name, :email, :role, :language, :team_value, :participation_due

  before_create :assign_jokers
  before_create :set_participation_due
  before_save { |user| user.email = email.downcase }

  validates :first_name, :last_name, :team_name, :role, :language, :team_value, presence: true
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: email_regex },uniqueness: { case_sensitive: false }

  scope :admins, where(role: 'admin')

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
end
