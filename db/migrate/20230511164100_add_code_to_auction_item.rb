class AddCodeToAuctionItem < ActiveRecord::Migration[7.0]
  def change
    add_column :auction_items, :code, :string
  end
end
