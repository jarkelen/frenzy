class AddBaseNrToUsers < ActiveRecord::Migration
  def change
    add_column :users, :base_nr, :integer
  end
end
