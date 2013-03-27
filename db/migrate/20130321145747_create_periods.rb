class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :period_nr
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
