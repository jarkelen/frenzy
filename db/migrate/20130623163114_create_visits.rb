class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :visit_nr
      t.datetime :visit_date
      t.integer :league_id
      t.integer :home_club_id
      t.integer :away_club_id
      t.string :ground
      t.string :street
      t.string :city
      t.float :longitude
      t.float :latitude
      t.boolean :gmaps
      t.string :result
      t.string :season
      t.string :kickoff
      t.integer :gate
      t.integer :user_id

      t.timestamps
    end
  end
end
