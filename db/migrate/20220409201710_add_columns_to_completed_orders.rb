class AddColumnsToCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_orders, :name, :string
    add_column :completed_orders, :email, :string
  end
end
