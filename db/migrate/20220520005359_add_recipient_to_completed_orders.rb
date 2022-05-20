class AddRecipientToCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_orders, :recipient, :string
  end
end
