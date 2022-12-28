class AddColorsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :color_option_1, :string
  end
end
