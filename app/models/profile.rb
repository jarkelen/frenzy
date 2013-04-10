class Profile < ActiveRecord::Base
  belongs_to :user

  attr_accessible :bio, :facebook, :favorite_club, :location, :profile_photo, :twitter, :user_id, :website

  before_save :check_protocol
  validates :user_id, presence: true

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
