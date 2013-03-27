class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string  :current_period
      t.integer :max_teamvalue
      t.integer :max_teamsize
      t.integer :max_jokers
      t.boolean :participation

      t.timestamps
    end
  end
end
