class RemoveFavoriteEnglishClubFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :favorite_club
    rename_column :users, :favorite_english_club, :favorite_club
  end

end
