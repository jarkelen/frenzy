class ChangeForeignKeys < ActiveRecord::Migration
  def up
    add_column :jokers, :player_id, :integer
    add_column :selections, :player_id, :integer
    add_column :rankings, :player_id, :integer
  end

  def down
    remove_column :jokers, :player_id
    remove_column :selections, :player_id
    remove_column :rankings, :player_id
  end
end
