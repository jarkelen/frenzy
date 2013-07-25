class CleanupUserIds < ActiveRecord::Migration
  def up
    remove_column :jokers, :user_id
    remove_column :rankings, :user_id
    remove_column :selections, :user_id
  end

  def down
  end
end
