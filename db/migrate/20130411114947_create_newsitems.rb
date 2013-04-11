class CreateNewsitems < ActiveRecord::Migration
  def change
    create_table :newsitems do |t|
      t.string :title_nl
      t.string :title_en
      t.text :content_nl
      t.text :content_en

      t.timestamps
    end
  end
end
