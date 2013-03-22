class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :score
      t.integer :gameround_id
      t.integer :club_id

      t.timestamps
    end
  end
end
