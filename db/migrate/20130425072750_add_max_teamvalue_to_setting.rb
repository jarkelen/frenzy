class AddMaxTeamvalueToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :max_teamvalue, :integer
  end
end
