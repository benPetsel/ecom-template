class AddSessionIdentityToCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_orders, :session_identity, :string
  end
end
