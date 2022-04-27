# frozen_string_literal: true
#ENV['SECRET_KEY']
#ENV['PUBLISHABLE_KEY']
Rails.configuration.stripe ={
    publishable_key: ENV['PUBLISHABLE_KEY'] ,
    secret_key: ENV['SECRET_KEY']
    
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = ENV['SIGNING_SECRET']


