require "test_helper"

class CompletedOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @completed_order = completed_orders(:one)
  end

  test "should get index" do
    get completed_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_completed_order_url
    assert_response :success
  end

  test "should create completed_order" do
    assert_difference("CompletedOrder.count") do
      post completed_orders_url, params: { completed_order: { address: @completed_order.address, carrier_acct_id: @completed_order.carrier_acct_id, charge: @completed_order.charge, item_id: @completed_order.item_id, item_name: @completed_order.item_name, order_id: @completed_order.order_id, quantity: @completed_order.quantity, rate_id: @completed_order.rate_id, shipment_id: @completed_order.shipment_id } }
    end

    assert_redirected_to completed_order_url(CompletedOrder.last)
  end

  test "should show completed_order" do
    get completed_order_url(@completed_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_completed_order_url(@completed_order)
    assert_response :success
  end

  test "should update completed_order" do
    patch completed_order_url(@completed_order), params: { completed_order: { address: @completed_order.address, carrier_acct_id: @completed_order.carrier_acct_id, charge: @completed_order.charge, item_id: @completed_order.item_id, item_name: @completed_order.item_name, order_id: @completed_order.order_id, quantity: @completed_order.quantity, rate_id: @completed_order.rate_id, shipment_id: @completed_order.shipment_id } }
    assert_redirected_to completed_order_url(@completed_order)
  end

  test "should destroy completed_order" do
    assert_difference("CompletedOrder.count", -1) do
      delete completed_order_url(@completed_order)
    end

    assert_redirected_to completed_orders_url
  end
end
