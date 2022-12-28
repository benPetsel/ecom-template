class AddCartnoticeToManagements < ActiveRecord::Migration[7.0]
  def change
    add_column :managements, :cart_notice_inuse, :boolean
    add_column :managements, :cart_notice, :string
  end
end
