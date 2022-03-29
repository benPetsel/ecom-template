# frozen_string_literal: true
#ENV['SECRET_KEY']
#ENV['PUBLISHABLE_KEY']
Rails.configuration.stripe ={
    publishable_key: "pk_test_51HkuqiDQ3eSM34fjL8eIBuBqZoVZdPAWDqo6MSG74tVkMSKup1EccKzt71pVhC6EkVxQokRHATlqCYBwFwIEurMt00pAdNWRZq" ,
    secret_key: "sk_test_51HkuqiDQ3eSM34fjtVUtqsJmBhnbGMxSx665pD6i2IU6qmCSpX63sxbbJl3bPEoCl3gEmwdc4mLN7jkKC4pYK0Fm008IcDodSV"
    
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = "whsec_184a94c089d1c724a46b64031bb16e17202b107c107be4710695634f18fc40ab"

StripeEvent.configure do |events|
    events.subscribe 'charge.failed' do |event|
      # Define subscriber behavior based on the event object
      event.class       #=> Stripe::Event
      event.type        #=> "charge.failed"
      event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
    end
  
    events.all do |event|
      # Handle all event types - logging, etc.
    end
  end