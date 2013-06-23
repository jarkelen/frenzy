# == Schema Information
#
# Table name: visits
#
#  id           :integer          not null, primary key
#  visit_nr     :integer
#  visit_date   :datetime
#  league_id    :integer
#  home_club_id :integer
#  away_club_id :integer
#  ground       :string(255)
#  street       :string(255)
#  city         :string(255)
#  longitude    :float
#  latitude     :float
#  gmaps        :boolean
#  result       :string(255)
#  season       :string(255)
#  kickoff      :string(255)
#  gate         :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Visit < ActiveRecord::Base
  belongs_to :user

  acts_as_gmappable

  attr_accessible :away_club_id, :city, :gate, :ground, :home_club_id, :away_club_id, :kickoff, :latitude, :longitude, :gmaps, :league_id, :result,
                  :season, :street, :user_id, :visit_date, :visit_nr

  validates :city, :street, :ground, :result, :visit_nr, presence: true

  def gmaps4rails_address
    "#{self.street}, #{self.city}"
  end

  def gmaps4rails_infowindow
    club = Club.find(self.home_club_id)
    "<p>#{club.club_name}</p>
     <p>#{self.ground}</p>
     <p><a href='/visits/#{self.id}'>view details</a></p>"
  end

end
