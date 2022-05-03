class AddColumnToManagements < ActiveRecord::Migration[7.0]
  def change
    add_column :managements, :ship_company, :string
    add_column :managements, :ship_city, :string
    add_column :managements, :ship_state, :string
    add_column :managements, :ship_zip, :string
  end
end
