class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :club_name
      t.integer :period1
      t.integer :period2
      t.integer :period3
      t.integer :period4
      t.integer :league_id

      t.timestamps
    end
  end
end
