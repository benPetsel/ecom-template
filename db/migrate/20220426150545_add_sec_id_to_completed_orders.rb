class AddSecIdToCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_orders, :secID, :integer
  end
end
