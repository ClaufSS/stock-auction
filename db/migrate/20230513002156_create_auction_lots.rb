class CreateAuctionLots < ActiveRecord::Migration[7.0]
  def change
    create_table :auction_lots do |t|
      t.string :code
      t.datetime :start_date
      t.datetime :end_date
      t.float :start_price
      t.float :min_bid_diff
      t.integer :status, default: 0
      t.references :creator_user, null: false, foreign_key: {to_table: :users}
      t.references :evaluator_user, null: true, foreign_key: {to_table: :users}
      t.references :winner_bidder, null: true, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
