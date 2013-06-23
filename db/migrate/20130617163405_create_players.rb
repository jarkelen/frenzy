class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :rosettes, default: 0
      t.integer :medals, default: 0
      t.integer :cups, default: 0
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end
  end
end
