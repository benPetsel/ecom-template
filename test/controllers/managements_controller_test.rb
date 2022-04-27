require "test_helper"

class ManagementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @management = managements(:one)
  end

  test "should get index" do
    get managements_url
    assert_response :success
  end

  test "should get new" do
    get new_management_url
    assert_response :success
  end

  test "should create management" do
    assert_difference("Management.count") do
      post managements_url, params: { management: { about_page: @management.about_page, about_text: @management.about_text, address_card_text: @management.address_card_text, brand_name: @management.brand_name, buisness_address: @management.buisness_address, buisness_card: @management.buisness_card, contact_page: @management.contact_page, email: @management.email, email_card: @management.email_card, email_card_text: @management.email_card_text, facebook: @management.facebook, footer_text: @management.footer_text, home_page_text: @management.home_page_text, instagram: @management.instagram, phone: @management.phone, phone_card: @management.phone_card, phone_card_text: @management.phone_card_text, shop_text: @management.shop_text, testimonial_1_name: @management.testimonial_1_name, testimonial_1_text: @management.testimonial_1_text, testimonial_2_name: @management.testimonial_2_name, testimonial_2_text: @management.testimonial_2_text, testimonial_3_name: @management.testimonial_3_name, testimonial_3_text: @management.testimonial_3_text, testimonials: @management.testimonials, twitter: @management.twitter } }
    end

    assert_redirected_to management_url(Management.last)
  end

  test "should show management" do
    get management_url(@management)
    assert_response :success
  end

  test "should get edit" do
    get edit_management_url(@management)
    assert_response :success
  end

  test "should update management" do
    patch management_url(@management), params: { management: { about_page: @management.about_page, about_text: @management.about_text, address_card_text: @management.address_card_text, brand_name: @management.brand_name, buisness_address: @management.buisness_address, buisness_card: @management.buisness_card, contact_page: @management.contact_page, email: @management.email, email_card: @management.email_card, email_card_text: @management.email_card_text, facebook: @management.facebook, footer_text: @management.footer_text, home_page_text: @management.home_page_text, instagram: @management.instagram, phone: @management.phone, phone_card: @management.phone_card, phone_card_text: @management.phone_card_text, shop_text: @management.shop_text, testimonial_1_name: @management.testimonial_1_name, testimonial_1_text: @management.testimonial_1_text, testimonial_2_name: @management.testimonial_2_name, testimonial_2_text: @management.testimonial_2_text, testimonial_3_name: @management.testimonial_3_name, testimonial_3_text: @management.testimonial_3_text, testimonials: @management.testimonials, twitter: @management.twitter } }
    assert_redirected_to management_url(@management)
  end

  test "should destroy management" do
    assert_difference("Management.count", -1) do
      delete management_url(@management)
    end

    assert_redirected_to managements_url
  end
end
