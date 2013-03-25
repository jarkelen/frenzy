class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :home_club_id
      t.integer :away_club_id
      t.integer :home_score
      t.integer :away_score
      t.integer :gameround_id

      t.timestamps
    end
  end
end
