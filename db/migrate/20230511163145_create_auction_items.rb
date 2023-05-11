class CreateAuctionItems < ActiveRecord::Migration[7.0]
  def change
    create_table :auction_items do |t|
      t.string :name
      t.text :description
      t.float :weight
      t.float :width
      t.float :height
      t.float :depth
      t.references :category_item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
