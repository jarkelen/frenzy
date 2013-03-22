class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :club_home_id
      t.integer :club_away_id
      t.integer :score_home
      t.integer :score_away
      t.integer :gameround_id

      t.timestamps
    end
  end
end
