class RemoveStatusFromLot < ActiveRecord::Migration[7.0]
  def change
    remove_column :lots, :status, :integer
  end
end
