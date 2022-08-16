class AddTaxToManagements < ActiveRecord::Migration[7.0]
  def change
    add_column :managements, :tax_rate, :float
    add_column :managements, :title_tag, :string
  end
end
