class CreateGamerounds < ActiveRecord::Migration
  def change
    create_table :gamerounds do |t|
      t.integer :number
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :processed
      t.integer :period_id

      t.timestamps
    end
  end
end
