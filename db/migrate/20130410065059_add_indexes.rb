class AddIndexes < ActiveRecord::Migration
  def change
    add_index :clubs, :league_id
    add_index :profiles, :user_id
    add_index :gamerounds, :period_id
    add_index :jokers, :gameround_id
    add_index :jokers, :club_id
    add_index :jokers, :user_id
    add_index :rankings, :gameround_id
    add_index :rankings, :user_id
    add_index :results, :gameround_id
    add_index :results, :home_club_id
    add_index :results, :away_club_id
    add_index :scores, :gameround_id
    add_index :scores, :club_id
    add_index :selections, :user_id
    add_index :selections, :club_id
  end
end
