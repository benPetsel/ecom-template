class AddSecondaryHeadingToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :secondary_heading, :string
  end
end
