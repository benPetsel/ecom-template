class AddColoroptionsToCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :completed_orders, :color_options, :string
  end
end
