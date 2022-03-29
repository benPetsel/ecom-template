class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :catagory
      t.text :description
      t.integer :price
      t.integer :old_price
      t.boolean :on_sale
      t.boolean :sold_out
      t.boolean :featured
      t.integer :quantity

      t.timestamps
    end
  end
end
