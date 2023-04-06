class AddImagenumberToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :image_number, :integer
  end
end
