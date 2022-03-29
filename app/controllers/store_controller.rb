class StoreController < ApplicationController
  require 'stripe'
  require 'easypost'
  
  skip_before_action :verify_authenticity_token
  before_action do
    
   if !session[:forminfo] 
    session[:forminfo] = {'street' => "", 'city' => "", 
          'state' => "", 'zip' => "", 
          'service' => "", 'shipment_id' => "", 'shipment_cost' => 0,
          'carrier' => ""}
   end
  end

  configure do
    EasyPost.api_key = 'EZTKbc4f3c6f313a4ce191f6f7c8b4c47838dSMcmhMUTDZ0sV8002p83A'
    Stripe.api_key = "sk_test_51HkuqiDQ3eSM34fjtVUtqsJmBhnbGMxSx665pD6i2IU6qmCSpX63sxbbJl3bPEoCl3gEmwdc4mLN7jkKC4pYK0Fm008IcDodSV"
  end

  
  def index
    @products = Product.all
    total_num_products = @products.count

    #this handy thing sets the column number to be the most apetising :)
     if total_num_products > 5
      mod_test = total_num_products % 5
      @collm = 5
        if mod_test >  total_num_products % 4
          mod_test = total_num_products % 4
          @collm = 4
        end
        if mod_test >  total_num_products % 3
          mod_test = total_num_products % 3
          @collm = 3
        end
        
     end
    session[:cart] ||= {}
    
  end

def cart
  @products = Product.all
  @cart = session[:cart]
  if session[:shipmentrate]
  @shipmentRates = EasyPost::Shipment.retrieve(session[:shipmentrate]) 
  end
  
end

def store_show
  @product =  Product.find(params[:id]) 
end

def contact
end

def add_to_cart
  

    if !session[:cart].include?(params[:id])
        session[:cart][params[:id]] = 1 
        redirect_to cart_path
    end 
end


def delete_item
  session[:cart].delete(params[:id])
  redirect_to cart_path
end

def add_one
  session[:cart][params[:id]] += 1 
  redirect_to cart_path
end

def sub_one
  if session[:cart][params[:id]] > 1
    session[:cart][params[:id]] -= 1 
  else
    session[:cart][params[:id]] = 1 
  end
  redirect_to cart_path
end



def create
  
data = params[:shipping_selection]
fixed_data = JSON.parse(data)

  @products = Product.all
  @cart = session[:cart]
  @cartItems = []
  @salesTax = 0
  tax_rate = 0.07
  @zipfromDB = ""
  @adressDesk = ""
  @phoneDesk = ""
  shipping_rate = (fixed_data["rate"].to_f * 100).to_i
  shipping_service = fixed_data["service"]
  shipping_rate_id = fixed_data["id"]
  shipping_shipment_id = fixed_data["shipment_id"]
  shipping_carrier_account_id = fixed_data["carrier_account_id"]
  
  

  
      @cart.each do |id| 
      items = @products.find(id[0])
  


            @salesTax = @salesTax + items.price
        
             
            item ={
              price_data: {
                currency: 'USD',
                product_data: {
                    name: items.name,
                    description: items.description,
                    metadata: {
                        item_id: id[0].to_s
                  }
                },
                unit_amount: (items.price * 100).to_i
              },
              
              
              quantity: id[1],
             
              

            }
            @cartItems.push item
        
      end

      @salesTax = @salesTax * tax_rate
      item ={

        price_data: {
          currency: 'USD',
          product_data: {
              name: "Sales Tax",
            
              metadata: {
                  item_id: "tax"
            }
          },
          unit_amount:  (@salesTax * 100).to_i
        },
          
              quantity: 1

            }
            @cartItems.push item

      #TO DO add prices and products to the stripe dashbord programatically 
      # https://stripe.com/docs/products-prices/manage-prices?dashboard-or-api=api
      # this will need to be integrated into the product craetion portal soon.
      # this is also important for more accurate tax collection as Stripe requires a price object 
      #to calculate tax
        @session = Stripe::Checkout::Session.create(
              payment_method_types: ['card'],
              line_items: @cartItems ,
              mode: 'payment',
              shipping_options: [
    {
      shipping_rate_data: {
        
        type: 'fixed_amount',
        fixed_amount: {
          amount: shipping_rate,
          currency: 'usd',
        },
        display_name: shipping_service,
        delivery_estimate: {
          minimum: {
            unit: 'business_day',
            value: 1,
          },
          maximum: {
            unit: 'business_day',
            value: 1,
          },
        },
        metadata: {
          street: session[:forminfo]['street'] ,
          city: session[:forminfo]['city'] ,
          state: session[:forminfo]['state'], 
          zip: session[:forminfo]['zip'] ,
          rate_id: shipping_rate_id ,
          shipment_id: shipping_shipment_id ,
          carrier_acct_id: shipping_carrier_account_id 

        }
      },
    },
  ],
              success_url: store_success_url ,
              cancel_url: store_cancel_url
    
    
        )
        redirect_to @session.url, allow_other_host: true
       
    
end


def success;
end

def cancel;
end







def shipping_info
  session[:shipmentrate] = {}


  toAddress = EasyPost::Address.create(
    verify: ["delivery"],
  company: 'EasyPost',
  street1: params[:street],
  city: params[:city],
  state: params[:state],
  zip: params[:zip]
)

puts toAddress.verifications.delivery.success


if toAddress.verifications.delivery.success

      #change to env variable adress and switch 
      #create to .new I think -- Check on this!
      fromAddress = EasyPost::Address.create(
        company: 'EasyPost',
        street1: '417 Montgomery Street',
        street2: '5th Floor',
        city: 'San Francisco',
        state: 'CA',
        zip: '94104',
        phone: '415-528-7555'
      )


# add function for iterating through cart and creating total parcel size and wight
#return total len wid height and weight
    parcel = EasyPost::Parcel.create(
      length: 3,
      width: 3,
      height: 3,
      weight: 5
    )

    shipment = EasyPost::Shipment.create(
      to_address: toAddress,
      from_address: fromAddress,
      parcel: parcel
    )


    ## Iterating through rates object printing out
    ## the carrier, service level, rate, and id
    ## of each possible rate. 
    shipment.rates.each do |rate|
      puts(rate.carrier)
      puts(rate.service)
      puts(rate.rate)
      puts(rate.id)
    end




    session[:shipmentrate] = shipment.id
    session[:forminfo]['street'] = params[:street] 
    session[:forminfo]['city'] = params[:city]
    session[:forminfo]['state'] = params[:state]
    session[:forminfo]['zip'] = params[:zip]
else
  session[:shipmentrate] = nil
  session[:forminfo]['street'] = params[:street] 
  session[:forminfo]['city'] = params[:city]
  session[:forminfo]['state'] = params[:state]
  session[:forminfo]['zip'] = params[:zip]
end
redirect_to cart_path


end



end

