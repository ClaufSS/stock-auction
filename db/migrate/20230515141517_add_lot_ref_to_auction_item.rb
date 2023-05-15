class AddLotRefToAuctionItem < ActiveRecord::Migration[7.0]
  def change
    add_reference :auction_items, :lot, null: true, foreign_key: true
  end
end
