class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.integer :club_id
      t.integer :user_id

      t.timestamps
    end
  end
end
