class WebhooksController < ApplicationController
  require 'stripe'
    #skip_before_action :authenticate_user
    skip_before_action :verify_authenticity_token



    

  
  def create 
    endpoint_secret = "whsec_184a94c089d1c724a46b64031bb16e17202b107c107be4710695634f18fc40ab"
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil
  
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError => e
      # Invalid payload
      head 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      head 400
      return
    end
  
    # Handle the event
    case event.type
    when 'charge.succeeded'
      puts "A Charge Success!!: #{event.type}"
      

    when 'checkout.session.completed'
      checkout_session = event.data.object
      line_items = Stripe::Checkout::Session.list_line_items( checkout_session.id, {limit: 50})
      line_items = line_items.data
      shipping_details = Stripe::ShippingRate.retrieve(
        checkout_session.shipping_options[0].shipping_rate,
      )
      puts "SHIPPING DETAILS BELOW"
      shipping_details.each {|key, value| puts "#{key} is #{value}" }
      shipping_details = shipping_details.metadata
      order_details = []
     
      line_items.each{|n|
      current_product = Stripe::Product.retrieve(n.price.product) 
      #adds all products and sales tax to completed orders database
        CompletedOrder.create(
          order_id:checkout_session.id ,
           item_id:current_product.metadata.item_id.to_i ,
            item_name:n.description ,
             quantity:n.quantity.to_i ,
              charge:n.amount_total.to_i ,
               address:"N/A",
                rate_id:"N/A" ,
                shipment_id:"N/A" ,
                 carrier_acct_id:"N/A" )
          
      }
      # adds shipping to database
        CompletedOrder.create(
          order_id:checkout_session.id ,
           item_id: "shipping" ,
            item_name: 'shipping total' ,
             quantity: 1 ,
              charge: checkout_session.shipping_options[0].shipping_amount,
               address: shipping_details.street + " " + shipping_details.city  + " " + shipping_details.state + " " + shipping_details.zip ,
                rate_id: shipping_details.rate_id ,
                 shipment_id: shipping_details.shipment_id ,
                  carrier_acct_id: shipping_details.carrier_acct_id )
       
      
      
      
    when 'payment_intent.created'
      puts "A payment intent was created: #{event.type}"
      
    when 'payment_intent.succeeded'
      payment_intent = event.data.object # contains a Stripe::PaymentIntent
      puts 'PaymentIntent was successful!'
      
    when 'payment_method.attached'
      payment_method = event.data.object # contains a Stripe::PaymentMethod
      puts 'PaymentMethod was attached to a Customer!'
    # ... handle other event types
    else
      puts "Unhandled event type: #{event.type}"
    end
  
    head 200
  end
end

