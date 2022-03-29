class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :length, :integer
    add_column :products, :width, :integer
    add_column :products, :height, :integer
    add_column :products, :weight, :integer
  end
end
