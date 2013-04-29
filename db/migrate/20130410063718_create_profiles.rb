class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :location
      t.string :website
      t.string :bio
      t.string :twitter
      t.string :facebook
      t.string :profile_photo
      t.string :favorite_club
      t.integer :user_id

      t.timestamps
    end
  end
end
