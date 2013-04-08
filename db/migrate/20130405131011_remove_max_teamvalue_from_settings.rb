class RemoveMaxTeamvalueFromSettings < ActiveRecord::Migration
  def change
    remove_column :settings, :max_teamvalue
  end
end
