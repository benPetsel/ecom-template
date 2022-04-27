class CreateManagements < ActiveRecord::Migration[7.0]
  def change
    create_table :managements do |t|
      t.boolean :contact_page
      t.boolean :about_page
      t.text :about_text
      t.text :shop_text
      t.boolean :phone_card
      t.text :phone_card_text
      t.string :phone
      t.string :brand_name
      t.boolean :email_card
      t.text :email_card_text
      t.string :email
      t.boolean :buisness_card
      t.text :buisness_address
      t.text :address_card_text
      t.text :footer_text
      t.text :home_page_text
      t.boolean :testimonials
      t.string :testimonial_1_name
      t.text :testimonial_1_text
      t.string :testimonial_2_name
      t.text :testimonial_2_text
      t.string :testimonial_3_name
      t.text :testimonial_3_text
      t.string :twitter
      t.string :facebook
      t.string :instagram

      t.timestamps
    end
  end
end
