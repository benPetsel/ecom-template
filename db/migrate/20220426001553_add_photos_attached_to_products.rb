class AddPhotosAttachedToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :photos_attached, :boolean
  end
end
