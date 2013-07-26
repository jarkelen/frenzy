class CleanupUserIds < ActiveRecord::Migration
  def up
    remove_column :jokers, :user_id
    remove_column :rankings, :user_id
    remove_column :selections, :user_id
    remove_column :users, :assigned_jokers
    remove_column :users, :participation_due
  end

  def down
  end
end
