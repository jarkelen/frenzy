class MoveUserFieldsToPlayer < ActiveRecord::Migration
  def up
    add_column :players, :team_value, :integer, default: 125
    add_column :players, :assigned_jokers, :integer
    add_column :players, :participation_due, :datetime
  end

  def down
    remove_column :players, :team_value
    remove_column :players, :assigned_jokers
    remove_column :players, :participation_due
  end
end