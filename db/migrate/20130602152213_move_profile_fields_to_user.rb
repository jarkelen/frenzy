class MoveProfileFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :website, :string
    add_column :users, :bio, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :favorite_club, :string
    add_column :users, :favorite_english_club, :integer
  end

end
