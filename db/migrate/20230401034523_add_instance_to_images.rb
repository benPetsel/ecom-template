class AddInstanceToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :instance_number, :integer
  end
end
