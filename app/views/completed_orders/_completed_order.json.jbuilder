json.extract! completed_order, :id, :order_id, :item_id, :item_name, :quantity, :charge, :address, :rate_id, :shipment_id, :carrier_acct_id, :created_at, :updated_at
json.url completed_order_url(completed_order, format: :json)
