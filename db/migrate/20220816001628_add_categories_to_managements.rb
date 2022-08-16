class AddCategoriesToManagements < ActiveRecord::Migration[7.0]
  def change
    add_column :managements, :categories, :string
  end
end
