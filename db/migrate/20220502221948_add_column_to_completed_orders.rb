class AddColumnToCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_orders, :order_completed, :boolean
  end
end
