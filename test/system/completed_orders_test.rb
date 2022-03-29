require "application_system_test_case"

class CompletedOrdersTest < ApplicationSystemTestCase
  setup do
    @completed_order = completed_orders(:one)
  end

  test "visiting the index" do
    visit completed_orders_url
    assert_selector "h1", text: "Completed orders"
  end

  test "should create completed order" do
    visit completed_orders_url
    click_on "New completed order"

    fill_in "Address", with: @completed_order.address
    fill_in "Carrier acct", with: @completed_order.carrier_acct_id
    fill_in "Charge", with: @completed_order.charge
    fill_in "Item", with: @completed_order.item_id
    fill_in "Item name", with: @completed_order.item_name
    fill_in "Order", with: @completed_order.order_id
    fill_in "Quantity", with: @completed_order.quantity
    fill_in "Rate", with: @completed_order.rate_id
    fill_in "Shipment", with: @completed_order.shipment_id
    click_on "Create Completed order"

    assert_text "Completed order was successfully created"
    click_on "Back"
  end

  test "should update Completed order" do
    visit completed_order_url(@completed_order)
    click_on "Edit this completed order", match: :first

    fill_in "Address", with: @completed_order.address
    fill_in "Carrier acct", with: @completed_order.carrier_acct_id
    fill_in "Charge", with: @completed_order.charge
    fill_in "Item", with: @completed_order.item_id
    fill_in "Item name", with: @completed_order.item_name
    fill_in "Order", with: @completed_order.order_id
    fill_in "Quantity", with: @completed_order.quantity
    fill_in "Rate", with: @completed_order.rate_id
    fill_in "Shipment", with: @completed_order.shipment_id
    click_on "Update Completed order"

    assert_text "Completed order was successfully updated"
    click_on "Back"
  end

  test "should destroy Completed order" do
    visit completed_order_url(@completed_order)
    click_on "Destroy this completed order", match: :first

    assert_text "Completed order was successfully destroyed"
  end
end
