class AddParticipationDueToUsers < ActiveRecord::Migration
  def change
    add_column :users, :participation_due, :datetime
  end
end
