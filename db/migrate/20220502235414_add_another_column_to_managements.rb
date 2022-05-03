class AddAnotherColumnToManagements < ActiveRecord::Migration[7.0]
  def change
    add_column :managements, :ship_street, :string
  end
end
