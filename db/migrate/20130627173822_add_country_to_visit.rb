class AddCountryToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :country, :string
  end
end
