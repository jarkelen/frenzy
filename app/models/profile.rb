class Profile < ActiveRecord::Base
  belongs_to :user

  attr_accessible :bio, :facebook, :favorite_club, :location, :profile_photo, :twitter, :user_id, :website

  before_save :check_protocol
  validates :user_id, presence: true
  validates_length_of :bio, maximum: 140
  validates_length_of :facebook, :twitter, :favorite_club, :location, maximum: 50

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

end
