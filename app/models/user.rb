class User < ActiveRecord::Base
  include Clearance::User

  attr_accessible :first_name, :last_name, :nickname, :email, :role, :language

  validates :first_name, :last_name, :nickname, :email, :role, :language, presence: true
end
