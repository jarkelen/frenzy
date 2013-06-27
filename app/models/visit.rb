# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  visit_nr   :integer
#  visit_date :datetime
#  league     :string(255)
#  home_club  :string(255)
#  away_club  :string(255)
#  ground     :string(255)
#  street     :string(255)
#  city       :string(255)
#  country    :string(255)
#  longitude  :float
#  latitude   :float
#  gmaps      :boolean
#  result     :string(255)
#  season     :string(255)
#  kickoff    :string(255)
#  gate       :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ActiveRecord::Base
  belongs_to :user

  acts_as_gmappable

  attr_accessible :away_club, :city, :gate, :ground, :home_club, :kickoff, :latitude, :longitude, :gmaps, :league, :result,
                  :season, :street, :country, :user_id, :visit_date, :visit_nr

  validates :city, :street, :country, :ground, :result, :visit_nr, presence: true

  def gmaps4rails_address
    "#{self.street}, #{self.city}, #{self.country}"
  end

  def gmaps4rails_infowindow
    "<p>#{self.home_club}</p>
     <p>#{self.ground}</p>
     <p><a href='/visits/#{self.id}'>view details</a></p>"
  end

end
