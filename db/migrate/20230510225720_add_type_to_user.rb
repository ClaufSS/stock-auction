class AddTypeToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user_type, :integer, default: 1
  end
end
