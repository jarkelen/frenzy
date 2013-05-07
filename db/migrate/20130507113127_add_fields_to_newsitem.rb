class AddFieldsToNewsitem < ActiveRecord::Migration
  def change
    add_column :newsitems, :sticky, :boolean
    add_column :newsitems, :priority, :string
  end
end
