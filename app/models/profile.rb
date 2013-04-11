class Profile < ActiveRecord::Base
  belongs_to :user

  attr_accessible :bio, :facebook, :favorite_club, :location, :profile_photo, :twitter, :user_id, :website

  before_save :check_protocol
  before_save :check_twitter
  before_save :check_facebook

  validates :user_id, presence: true
  validates_length_of :bio, maximum: 140
  validates_length_of :facebook, :twitter, :favorite_club, :location, maximum: 50

  mount_uploader :profile_photo, ProfileUploader
  #validates :profile_photo, file_size: { maximum: 0.5.megabytes.to_i }

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
      self.twitter = "https://twitter.com/#{self.twitter}"
    end
  end

  def check_facebook
    unless self.facebook.blank?
      self.facebook = "https://www.facebook.com/#{self.facebook}"
    end
  end
end
