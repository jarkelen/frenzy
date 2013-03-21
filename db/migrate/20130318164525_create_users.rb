class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users  do |t|
      t.timestamps :null => false
      t.string :first_name
      t.string :last_name
      t.string :team_name
      t.string :email, :null => false
      t.string :language
      t.string :role
      t.integer :jokers, :default => 46
      t.integer :team_value, :default => 125
      t.string :encrypted_password, :limit => 128, :null => false
      t.string :confirmation_token, :limit => 128
      t.string :remember_token, :limit => 128, :null => false
    end

    add_index :users, :email
    add_index :users, :remember_token
  end

  def self.down
    drop_table :users
  end
end
