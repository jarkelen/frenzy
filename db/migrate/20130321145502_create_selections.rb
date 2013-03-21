class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.string :club_id
      t.string :user_id

      t.timestamps
    end
  end
end
