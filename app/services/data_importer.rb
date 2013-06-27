class DataImporter
  require 'active_record'

  def import
    ActiveRecord::Base.establish_connection(
      adapter:  "postgresql",
      host:     "localhost",
      username: "johnvanarkelen",
      password: "",
      database: "mygroundhops_development"
    )

    visit = Visit.first
puts "VISIT #{visit.ground}"
    ActiveRecord::Base.establish_connection(
      adapter:  "postgresql",
      host:     "localhost",
      username: "johnvanarkelen",
      password: "",
      database: "frenzy_development"
    )

    visit = Visit.first
puts "VISIT #{visit.ground}"

    #Visit.create!(visit_nr: old_visit.match_nr, visit_date: old_visit.visit_date, league: old_visit.league_visited, home_club: old_visit.club_id, away_club: old_visit.club_away, ground: old_visit.ground, street: old_visit.address, city: old_visit.address, longitude: old_visit.longitude, latitude: old_visit.latitude, gmaps: true, result: old_visit.result, season: old_visit.season, kickoff: old_visit.kickoff, gate: old_visit.gate, user_id: 1)

    #old_visits.each do |old_visit|
    #  puts "OLD #{old_visit.ground}"
    #end
  end

end

=begin
    t.datetime "visit_date"
    t.integer  "club_away"
    t.string   "result"
    t.string   "season"
    t.string   "kickoff"
    t.integer  "gate"
    t.decimal  "ticket_price"
    t.integer  "league_visited"
    t.boolean  "countfor92"
    t.string   "ground"
    t.string   "address"
    t.integer  "club_id"
    t.integer  "match_nr"
    t.integer  "the92_nr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "programme"
    t.string   "ticket"
    t.integer  "rating_total"
    t.integer  "rating_match"
    t.integer  "rating_ground"
    t.integer  "rating_atmosphere"
    t.integer  "rating_trip"
    t.string   "photo1"
    t.string   "photo2"
    t.string   "photo3"
    t.string   "photo4"


=end