require "application_system_test_case"

class ManagementsTest < ApplicationSystemTestCase
  setup do
    @management = managements(:one)
  end

  test "visiting the index" do
    visit managements_url
    assert_selector "h1", text: "Managements"
  end

  test "should create management" do
    visit managements_url
    click_on "New management"

    check "About page" if @management.about_page
    fill_in "About text", with: @management.about_text
    fill_in "Address card text", with: @management.address_card_text
    fill_in "Brand name", with: @management.brand_name
    fill_in "Buisness address", with: @management.buisness_address
    check "Buisness card" if @management.buisness_card
    check "Contact page" if @management.contact_page
    fill_in "Email", with: @management.email
    check "Email card" if @management.email_card
    fill_in "Email card text", with: @management.email_card_text
    fill_in "Facebook", with: @management.facebook
    fill_in "Footer text", with: @management.footer_text
    fill_in "Home page text", with: @management.home_page_text
    fill_in "Instagram", with: @management.instagram
    fill_in "Phone", with: @management.phone
    check "Phone card" if @management.phone_card
    fill_in "Phone card text", with: @management.phone_card_text
    fill_in "Shop text", with: @management.shop_text
    fill_in "Testimonial 1 name", with: @management.testimonial_1_name
    fill_in "Testimonial 1 text", with: @management.testimonial_1_text
    fill_in "Testimonial 2 name", with: @management.testimonial_2_name
    fill_in "Testimonial 2 text", with: @management.testimonial_2_text
    fill_in "Testimonial 3 name", with: @management.testimonial_3_name
    fill_in "Testimonial 3 text", with: @management.testimonial_3_text
    check "Testimonials" if @management.testimonials
    fill_in "Twitter", with: @management.twitter
    click_on "Create Management"

    assert_text "Management was successfully created"
    click_on "Back"
  end

  test "should update Management" do
    visit management_url(@management)
    click_on "Edit this management", match: :first

    check "About page" if @management.about_page
    fill_in "About text", with: @management.about_text
    fill_in "Address card text", with: @management.address_card_text
    fill_in "Brand name", with: @management.brand_name
    fill_in "Buisness address", with: @management.buisness_address
    check "Buisness card" if @management.buisness_card
    check "Contact page" if @management.contact_page
    fill_in "Email", with: @management.email
    check "Email card" if @management.email_card
    fill_in "Email card text", with: @management.email_card_text
    fill_in "Facebook", with: @management.facebook
    fill_in "Footer text", with: @management.footer_text
    fill_in "Home page text", with: @management.home_page_text
    fill_in "Instagram", with: @management.instagram
    fill_in "Phone", with: @management.phone
    check "Phone card" if @management.phone_card
    fill_in "Phone card text", with: @management.phone_card_text
    fill_in "Shop text", with: @management.shop_text
    fill_in "Testimonial 1 name", with: @management.testimonial_1_name
    fill_in "Testimonial 1 text", with: @management.testimonial_1_text
    fill_in "Testimonial 2 name", with: @management.testimonial_2_name
    fill_in "Testimonial 2 text", with: @management.testimonial_2_text
    fill_in "Testimonial 3 name", with: @management.testimonial_3_name
    fill_in "Testimonial 3 text", with: @management.testimonial_3_text
    check "Testimonials" if @management.testimonials
    fill_in "Twitter", with: @management.twitter
    click_on "Update Management"

    assert_text "Management was successfully updated"
    click_on "Back"
  end

  test "should destroy Management" do
    visit management_url(@management)
    click_on "Destroy this management", match: :first

    assert_text "Management was successfully destroyed"
  end
end
