class CreateLots < ActiveRecord::Migration[7.0]
  def change
    create_table :lots do |t|
      t.string :code
      t.datetime :start_date
      t.datetime :end_date
      t.float :start_price
      t.float :min_bid
      t.integer :status
      t.references :register_user, null: false, foreign_key: {to_table: :users}
      t.references :approver_user, null: true, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
