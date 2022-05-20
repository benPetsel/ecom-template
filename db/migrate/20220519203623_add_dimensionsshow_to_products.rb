class AddDimensionsshowToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :dimensions_show, :boolean
  end
end
