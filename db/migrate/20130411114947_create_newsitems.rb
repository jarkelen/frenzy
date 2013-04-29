class CreateNewsitems < ActiveRecord::Migration
  def change
    create_table :newsitems do |t|
      t.string :title_nl
      t.string :title_en
      t.text :summary_nl
      t.text :summary_en
      t.text :content_nl
      t.text :content_en
      t.boolean :publish
      t.integer :user_id

      t.timestamps
    end
  end
end
