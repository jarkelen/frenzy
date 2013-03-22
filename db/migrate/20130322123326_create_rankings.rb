class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :total_score
      t.integer :gameround_id
      t.integer :user_id

      t.timestamps
    end
  end
end
