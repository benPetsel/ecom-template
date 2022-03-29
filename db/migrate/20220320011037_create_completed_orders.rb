class CreateCompletedOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :completed_orders do |t|
      t.string :order_id
      t.integer :item_id
      t.string :item_name
      t.integer :quantity
      t.integer :charge
      t.text :address
      t.string :rate_id
      t.string :shipment_id
      t.string :carrier_acct_id

      t.timestamps
    end
  end
end
