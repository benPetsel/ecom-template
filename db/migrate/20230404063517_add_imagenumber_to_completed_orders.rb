class AddImagenumberToCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_orders, :image_count, :integer
  end
end
