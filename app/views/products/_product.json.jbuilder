json.extract! product, :id, :name, :catagory, :description, :price, :old_price, :on_sale, :sold_out, :featured, :quantity, :created_at, :updated_at
json.url product_url(product, format: :json)
