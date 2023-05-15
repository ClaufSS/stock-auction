class AddStatusToAuctionItem < ActiveRecord::Migration[7.0]
  def change
    add_column :auction_items, :status, :integer, default: 0
  end
end
