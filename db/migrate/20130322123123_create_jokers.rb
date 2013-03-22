class CreateJokers < ActiveRecord::Migration
  def change
    create_table :jokers do |t|
      t.integer :gameround_id
      t.integer :user_id

      t.timestamps
    end
  end
end
