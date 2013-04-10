class Profile < ActiveRecord::Base
  include Clearance::User
  belongs_to :user

  attr_accessible :bio, :facebook, :favorite_club, :location, :profile_photo, :twitter, :website
  validates :user_id, presence: true

end
