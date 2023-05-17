class AddBidSupportToLot < ActiveRecord::Migration[7.0]
  def change
    add_reference :lots, :user_player, null: true, foreign_key: {to_table: :users}
    add_column :lots, :offer, :float, default: 0
  end
end
