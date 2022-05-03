class StoreController < ApplicationController
  require 'stripe'
  require 'easypost'
  
  skip_before_action :verify_authenticity_token
  

  before_action do
    @products = Product.all
      if !session[:forminfo] 
        session[:forminfo] = {'street' => "", 'city' => "", 
              'state' => "", 'zip' => "", 
              'service' => "", 'shipment_id' => "", 'shipment_cost' => 0,
              'carrier' => ""}
      end

      whole_cart = session[:cart]

    if session[:cart]
      whole_cart.each do |cart_item| 
        item = @products.find(cart_item[0])
        if item.quantity < 1
          whole_cart.delete(cart_item[0])
          item.sold_out = true
          item.save!
        elsif cart_item[1]["quan"] > item.quantity 
          cart_item[1]["quan"] = 1
        else
          #no action yet
        end
      end
    end


  end

  configure do
    EasyPost.api_key = ENV['EASYPOST_KEY']
    Stripe.api_key = ENV['SECRET_KEY']
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

  # set var if images have been uploaded to item with require_photos to true
  # allert to fire inside checkout form if no
  @all_images = Image.all
  @image = Image.new
  @session_id = session.id.to_s
  @products = Product.all
  @cart = session[:cart]
  @disable
  if @cart.empty?
    @disable = "disabled"
  else
    @disable = ""
  end
  
  if session[:shipmentrate]
  @shipmentRates = EasyPost::Shipment.retrieve(session[:shipmentrate]) 
  
  end
  
end

def about
end

def store_show
  @product =  Product.find(params[:id]) 

  if @product.sold_out? || @product.quantity < 1
    @button_text = "Sold Out"
    @path = store_show_path(@product.id)
    @get_post = :get
    @disabled = true
    @class = "mx-auto w-2/5 my-1 px-4 py-2 font-medium tracking-wide border-2 border-black bg-gray-400  text-gray-800 capitalize "
  else
    @button_text = "Add to Cart"
    @path = add_to_cart_path(@product.id)
    @get_post = :post
    @disabled = false
    @class = "mx-auto w-2/5 lg:my-5 my-1 px-4 py-2 font-medium tracking-wide text-blue-600 capitalize transition-colors duration-500 
    transform border-blue-500 border-2 hover:bg-blue-500 hover:text-white focus:outline-none focus:ring focus:ring-blue-300 focus:ring-opacity-80"
  end
end

def contact
end

def add_to_cart
  this_product =  Product.find(params[:id])
     
    
    if !session[:cart].include?(params[:id]) 
     
        session[:shipmentrate] = nil
        session[:cart][params[:id]] = {"quan" => 1 ,"has_pic" => false , "sec_id" => [] }
      if this_product.photos_attached? 
       session[:cart][params[:id]]["has_pic"] = true
       session[:cart][params[:id]]["sec_id"] = [1]
       attached_pic = Image.where(:sesh_id => session.id.to_s ).where(:item_id => params[:id] ).where(:secondary_id => 1 ).first
       if attached_pic
        old_values = session.to_hash
        reset_session
        session.update old_values.except('session_id')
       end
      end
      redirect_to cart_path
    else
      redirect_to cart_path
    end 
end


def delete_item
  session[:shipmentrate] = nil
  if session[:cart][params[:id]]["has_pic"] == true
    session[:cart][params[:id]]["sec_id"].each do |this_second_id|
      attached_pic = Image.where(:sesh_id => session.id.to_s ).where(:item_id => params[:id] ).where(:secondary_id => this_second_id ).first
      if attached_pic
        attached_pic.destroy
      end
    end
  end
  session[:cart].delete(params[:id])
  redirect_to cart_path
end

def add_one
  session[:shipmentrate] = nil
  this_product =  Product.find(params[:id]) 
  purchase_quantity = session[:cart][params[:id]]["quan"]
  if (purchase_quantity + 1) > this_product.quantity

  else
  session[:cart][params[:id]]["quan"] += 1 
    if session[:cart][params[:id]]["has_pic"] == true

       new_id = session[:cart][params[:id]]["sec_id"].last + 1
       session[:cart][params[:id]]["sec_id"].push new_id
    end
  end
  redirect_to cart_path
end

def sub_one
  session[:shipmentrate] = nil
  
  if session[:cart][params[:id]]["quan"] > 1
    session[:cart][params[:id]]["quan"] -= 1 
    if session[:cart][params[:id]]["has_pic"] == true
      attached_pic = Image.where(:sesh_id => session.id.to_s ).where(:item_id => params[:id] ).where(:secondary_id => session[:cart][params[:id]]["sec_id"].last ).first
      if attached_pic
        attached_pic.destroy
      end
      session[:cart][params[:id]]["sec_id"].pop
    end
  else
    session[:cart][params[:id]]["quan"] = 1 
    session[:cart][params[:id]]["sec_id"] = [1]
  end
  redirect_to cart_path
end



def create
  
data = params[:shipping_selection]
fixed_data = JSON.parse(data)

  @products = Product.all
  @cart = session[:cart]
  missing_photos = false
  @cart.each do |crap| 
    if crap[1]["has_pic"]
      crap[1]["sec_id"].each do |this_second_id|
        attached_pic = Image.where(:sesh_id => session.id.to_s ).where(:item_id => crap[0] ).where(:secondary_id => this_second_id ).first
        if attached_pic
        else
          missing_photos = true
        end
      end
    end
  end
  
  if missing_photos
    redirect_to cart_path, notice: 'Products are missing photos'
  else
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
        
             if id[1]["has_pic"] 
              id[1]["sec_id"].each do |second_id|
                item ={
              price_data: {
                currency: 'USD',
                product_data: {
                    name: items.name,
                    description: items.description,
                    metadata: {
                        item_id: id[0].to_s,
                        sec_id: second_id.to_s
                  }
                },
                unit_amount: (items.price * 100).to_i
              },
              
              quantity: 1,
             
            }
            @cartItems.push item

              end

             else
            item ={
              price_data: {
                currency: 'USD',
                product_data: {
                    name: items.name,
                    description: items.description,
                    metadata: {
                        item_id: id[0].to_s,
                        sec_id: "0"
                  }
                },
                unit_amount: (items.price * 100).to_i
              },
              
              quantity: id[1]["quan"],
             
            }
            @cartItems.push item
          end
        
      end

      @salesTax = @salesTax * tax_rate
      item ={

        price_data: {
          currency: 'USD',
          product_data: {
              name: "Sales Tax",
            
              metadata: {
                  item_id: "tax",
                  sec_id: "0"
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
        
        metadata: {
          street: session[:forminfo]['street'] ,
          city: session[:forminfo]['city'] ,
          state: session[:forminfo]['state'], 
          zip: session[:forminfo]['zip'] ,
          rate_id: shipping_rate_id ,
          shipment_id: shipping_shipment_id ,
          carrier_acct_id: shipping_carrier_account_id ,
          session_identity: session.id 

        }
      },
    },
  ],
              success_url: store_success_url ,
              cancel_url: store_cancel_url
    
    
        )
        redirect_to @session.url, allow_other_host: true
       
end
end


def success;
session[:cart] = {}
session[:shipmentrate] = nil
end

def cancel;
end



def package_size
  products = Product.all
  cart = session[:cart]
  contents_dimentions = []
  contents_weight = 0
  total_volume = 0
  chosen_box = 0
  longest_side = []
  final_box = -1
  #below are the box dimentions in L W H order referenced from fedex standard box sizes 
  boxes = [[8,6,4],[8,8,8],[12,9,6],[11,11,11],[12,12,18],[13,9,11],[14,14,14],[16,16,16],[20,20,20],[22,22,22],[24,24,24],[28,28,28]]
  box_volume = 0
  cart.each do |id| 
    items = @products.find(id[0])
    new_dimentions = [items.length, items.width, items.height ]
    for i in 1..id[1]["quan"]
    contents_dimentions.push new_dimentions
    contents_weight += items.weight
    end
  end

  # the 2 loops below check the volume of the items compared to possible boxes and chooses the best fit with 30 percent extra space
  #////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  contents_dimentions.each do |lwh|
    volume = lwh[0] * lwh[1] * lwh[2]
    total_volume += volume
    longest_side.push lwh.max
  end

index = 0
  for i in boxes do
    volume = i[0] * i[1] * i[2]
    #assumes the volume in the box is 30% empty space
    volume = volume - (volume * 0.3)
    volume = volume.ceil 
    if volume > total_volume
      chosen_box = index
      break
    end
  index += 1
  end
  # /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  #from here we have the chosen aproximation in terms of volume using chosen_box

  
    longest_side = longest_side.max
    while final_box == -1
      box_failed = false
      boxes[chosen_box].each do |box_side|
        if longest_side > box_side
          box_failed = true
        end
      end
      if chosen_box != boxes.length() 
        if box_failed == true
          chosen_box += 1
        else
          final_box = chosen_box
        end
      else
        #this is the largest avalible box 
        final_box = chosen_box
      end
    end
      
  final_dimentions = boxes[final_box]
  final_dimentions.push contents_weight
  return final_dimentions
end




def shipping_info
  session[:shipmentrate] = {}
  owner_shipping = Management.first

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
        company: owner_shipping.ship_company,
        street1: owner_shipping.ship_street,
        city:  owner_shipping.ship_city,
        state: owner_shipping.ship_state,
        zip: owner_shipping.ship_zip,
  
      )

     length_width_height_weight = package_size()
# add function for iterating through cart and creating total parcel size and wight
#return total len wid height and weight
    parcel = EasyPost::Parcel.create(
      
      length: length_width_height_weight[0],
      width: length_width_height_weight[1],
      height: length_width_height_weight[2],
      weight: length_width_height_weight[3]
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


    puts "dimentions below"
    puts length_width_height_weight 
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

