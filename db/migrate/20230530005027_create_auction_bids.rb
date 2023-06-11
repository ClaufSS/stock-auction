class CreateAuctionBids < ActiveRecord::Migration[7.0]
  def change
    create_table :auction_bids do |t|
      t.references :auction_lot, null: false, foreign_key: true
      t.references :bidder, null: false, foreign_key: {to_table: :users}
      t.float :bid

      t.timestamps
    end
  end
end
