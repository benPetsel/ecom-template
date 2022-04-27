class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      t.string :sesh_id
      t.integer :item_id
      t.integer :secondary_id
      t.boolean :purchased

      t.timestamps
    end
  end
end
