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
        @total_item_number = 0
        cart_item[1].each do |item|
          @total_item_number = @total_item_number + item["quan"]
        end
        if item.quantity < 1
          whole_cart.delete(cart_item[0])
          item.sold_out = true
          item.save!
        elsif @total_item_number > item.quantity 
          #pop may cause issues with images UNSURE if error refer to here
          cart_item[1].pop
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
    
    session[:temp_color_option] = '0'
    @products = Product.all
    total_num_products = @products.count
    if @content.categories
      cat_shop_text = @content.categories 
      @cat_shop_arr = cat_shop_text.split(',')
    end
    

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
  
  @notice_message = @content.cart_notice_inuse
  if @content.cart_notice
    @notice_message_text = @content.cart_notice
  end
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
    #logic to check if color_option_1 is empty
#else 
if @product.color_option_1
   @color_arr = text_to_arr(@product.color_option_1)
else
  @color_arr = []
end
   # defaults to exeption on the first pass
   
    @selectedColor = []
#must be an empty array if there are no options

  
#if  an index is present then we are modifying a product.
  if params[:index]
    #currently_editing bool doesnt do anything currently
    @currently_editing = true
    @selectedColor.push(@testcookie["color_index"].to_s)
    @edit_path = :edit_options
    @edit_index = params[:index]
  else
    @currently_editing = false
    @testcookie = 'index does not exist'
    @selectedColor.push(session[:temp_color_option])
    @edit_path = :new_color_choice
    @edit_index = nil
  end


  if @product.sold_out? || @product.quantity < 1  
    @button_text = "Sold Out"
    @path = store_show_path(@product.id)
    @get_post = :get
    @disabled = true
    @class = "mx-auto w-2/5 my-1 px-4 py-2 font-medium tracking-wide border-2 border-black bg-gray-400  text-gray-800 capitalize "
  elsif params[:index]
    @button_text = "Done Editing"
    @path = cart_path()
    @get_post = :get
    @disabled = false
    @class = "mx-auto w-2/5 lg:my-5 my-1 px-4 py-2 font-medium tracking-wide text-blue-600 capitalize transition-colors duration-500 
    transform border-blue-500 border-2 hover:bg-blue-500 hover:text-white focus:outline-none focus:ring focus:ring-blue-300 focus:ring-opacity-80"
  else
    @button_text = "Add to Cart"
    @path = add_to_cart_path(@product.id)
    @get_post = :post
    @disabled = false
    @class = "mx-auto w-2/5 lg:my-5 my-1 px-4 py-2 font-medium tracking-wide text-blue-600 capitalize transition-colors duration-500 
    transform border-blue-500 border-2 hover:bg-blue-500 hover:text-white focus:outline-none focus:ring focus:ring-blue-300 focus:ring-opacity-80"
  end
end

def text_to_arr(arr)
  split_arr = arr.split(",")
  final_arr = []
  placeholder = []

  if split_arr[0] == ""
    split_arr.shift()
  end

  split_arr.each do |n| 
    placeholder.push(n)
    if placeholder.length == 3
      final_arr.push(placeholder)
      placeholder = []
    end
  end
 return final_arr
end

def contact
end

def find_instance_index(instance_num)
end

def add_to_cart
  this_product =  Product.find(params[:id])

  if this_product.color_option_1
    @color_arr = text_to_arr(this_product.color_option_1)
  else
    @color_arr = []
  end

  sec_id_arr = []

  
# if !session[:cart].include?(params[:id]) 
      
        session[:shipmentrate] = nil
        if !session[:cart][params[:id]]
        session[:cart][params[:id]] = []
        new_instance = 1
        session[:cart][params[:id]].push({"instance" => new_instance , "quan" => 1 ,"has_pic" => false , "sec_id" => [], "selected_color" => @color_arr[params[:selectedColor][0].to_i], "color_index" => params[:selectedColor][0].to_i  })
        puts session[:cart][params[:id]]
        else
        new_instance = (session[:cart][params[:id]].last)["instance"].to_i + 1 
        session[:cart][params[:id]].push({"instance" => new_instance  , "quan" => 1 ,"has_pic" => false , "sec_id" => [], "selected_color" => @color_arr[params[:selectedColor][0].to_i], "color_index" => params[:selectedColor][0].to_i })
        index_of_instance = session[:cart][params[:id]].length - 1
        puts session[:cart]
        end
#this will need to be changed to || product_options == true (or something like that)



       

      if this_product.photos_attached? 
        if this_product.image_number
          this_product.image_number.times do |i|
            sec_id_arr.push(i)
          end
        else
          sec_id_arr = [0]
        end

      session[:cart][params[:id]][index_of_instance.to_i]["sec_id"] = sec_id_arr
       session[:cart][params[:id]][index_of_instance.to_i]["has_pic"] = true

       #I have no idea what this does.... Reset the session if the image exits??? But why??? Shouldnt I destroy the image record?? 
       #What?? Should I do this Ahhhh
       attached_pic = Image.where(:sesh_id => session.id.to_s ).where(:item_id => params[:id] ).where(:instance_number => new_instance ).where(:secondary_id => sec_id_arr[0] ).first
       if attached_pic
        old_values = session.to_hash
        reset_session
        session.update old_values.except('session_id')
       end
      end
      redirect_to cart_path
    # else
    #   redirect_to cart_path
    # end 
end


def delete_item
  session[:shipmentrate] = nil
  
  session[:cart][params[:id]].each_with_index do | item, index |
    if item["instance"].to_i == params[:instance].to_i
      @selected_instance = index.to_s
    end
  end
  puts "selected INSTANCE:: " + @selected_instance.to_s
  if session[:cart][params[:id]][@selected_instance.to_i]["has_pic"] == true
    session[:cart][params[:id]][@selected_instance.to_i]["sec_id"].each do |this_second_id|
      attached_pic = Image.where(:sesh_id => session.id.to_s ).where(:item_id => params[:id] ).where(:instance_number => @selected_instance.to_i ).where(:secondary_id => this_second_id ).first
      if attached_pic
        attached_pic.destroy
      end
    end
  end

  if session[:cart][params[:id]].length > 1
    session[:cart][params[:id]].delete_at(@selected_instance.to_i)
  else
    session[:cart].delete(params[:id])
  end
  
  redirect_to cart_path
end

def edit_options
  this_product =  Product.find(params[:id]) 

  if this_product.color_option_1
    @color_arr = text_to_arr(this_product.color_option_1)
  end
  session[:cart][params[:id].to_s][params[:index].to_i]["selected_color"] = @color_arr[params[:choice].to_i]
  session[:cart][params[:id].to_s][params[:index].to_i]["color_index"] = params[:choice].to_s
  redirect_to store_show_path(this_product.id, :index => params[:index] )


end

def new_color_choice
  this_product =  Product.find(params[:id]) 
  session[:temp_color_option] = params[:choice]
  redirect_to store_show_path(this_product.id)
end

def add_one

  session[:shipmentrate] = nil
  this_product =  Product.find(params[:id]) 
  @purchase_quantity = 0
  @selected_instance = 0

  #loop through all instances of the item in question aka: params[id]
  session[:cart][params[:id]].each_with_index do |item, index|
    #check if the current item is the instance being modified
    if item["instance"].to_i == params[:instance].to_i
      @selected_instance = index
    end
    #add up the total number of THIS item currently in the cart accross all instances
    @purchase_quantity = @purchase_quantity + item["quan"].to_i
  end

  if (@purchase_quantity + 1) > this_product.quantity
    #a message declaring that there are no more for sale. 
  else
  session[:cart][params[:id]][@selected_instance.to_i]["quan"] += 1 
  end
  redirect_to cart_path
end

def sub_one
  session[:shipmentrate] = nil

  session[:cart][params[:id]].each_with_index do |item, index|
    #check if the current item is the instance being modified
    if item["instance"].to_i == params[:instance].to_i
      @selected_instance = index
    end
  end
  
  if session[:cart][params[:id]][@selected_instance.to_i]["quan"] > 1
    session[:cart][params[:id]][@selected_instance.to_i]["quan"] -= 1 
  
  else
    session[:cart][params[:id]][@selected_instance.to_i]["quan"] = 1
  end
  redirect_to cart_path
end



def create
  
data = params[:shipping_selection]
fixed_data = JSON.parse(data)
@posError = 0
  @products = Product.all
  @cart = session[:cart]
  missing_photos = false
  @cart.each do |crap| 
    crap[1].each do |obj|
      if obj["has_pic"]
        obj["sec_id"].each do |this_second_id|
          attached_pic = Image.where(:sesh_id => session.id.to_s ).where(:item_id => crap[0] ).where(:instance_number => obj["instance"]).where(:secondary_id => this_second_id ).first
          if attached_pic
          else
            missing_photos = true
            
          end
        end
      end
    end
  end
  
if missing_photos
    redirect_to cart_path, notice: "some items are missing photos" 
    #some items are missing photos
else
  @cartItems = []
  @salesTax = 0
  if @content.tax_rate
    tax_rate = @content.tax_rate.to_f / 100
  else
    tax_rate = 7.5 / 100
  end
  @zipfromDB = ""
  @adressDesk = ""
  @phoneDesk = ""
  shipping_rate = (fixed_data["rate"].to_f * 100).to_i
  shipping_service = fixed_data["service"]
  shipping_rate_id = fixed_data["id"]
  shipping_shipment_id = fixed_data["shipment_id"]
  shipping_carrier_account_id = fixed_data["carrier_account_id"]
  
  

  ###################### start of cart.each do
  @cart.each do |id| 
    items = @products.find(id[0])
    @salesTax = @salesTax + items.price
    id[1].each do |itemObj|
      if itemObj["selected_color"]
        color_options = itemObj["selected_color"].join(",")
      else
        color_options = "N/A"
      end
        
          item ={
              price_data: {
              currency: 'USD',
              product_data: {
                    name: items.name,
                    description: items.description,
                    metadata: {
                        item_id: id[0].to_s,
                        sec_id: itemObj["instance"],
                        col_op: color_options,
                        pic_num: itemObj["sec_id"].length.to_s
                        
                      }
                    },
                unit_amount: (items.price * 100).to_i
                },
              quantity: itemObj["quan"],
            }
            @cartItems.push item

    end   
  end
### end of cart.each do######################
      @salesTax = @salesTax * tax_rate
      item ={

        price_data: {
          currency: 'USD',
          product_data: {
              name: "Sales Tax",
            
              metadata: {
                  item_id: "tax",
                  sec_id: "0",
                  col_op: "N/A",
                  pic_num: "0"
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
          recp_name: session[:forminfo]['recp_name'] ,
          street: session[:forminfo]['street'] ,
          city: session[:forminfo]['city'] ,
          state: session[:forminfo]['state'], 
          zip: session[:forminfo]['zip'] ,
          rate_id: shipping_rate_id ,
          shipment_id: shipping_shipment_id ,
          # carrier_acct_ids previous value was: shipping_carrier_account_id  it has been replaced with the service name as it is currently unused
          carrier_acct_id: shipping_service ,
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
    @total_of_this_item = 0

    #newly modified code to calculate the total number of a specific item
    id[1].each do |item|
        @total_of_this_item = @total_of_this_item + item["quan"].to_i
    end
    for i in 1..@total_of_this_item.to_i
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
  company: params[:recp_name],
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
    session[:forminfo]['recp_name'] = params[:recp_name] 
    session[:forminfo]['street'] = params[:street] 
    session[:forminfo]['city'] = params[:city]
    session[:forminfo]['state'] = params[:state]
    session[:forminfo]['zip'] = params[:zip]
else
  session[:shipmentrate] = nil
  session[:forminfo]['recp_name'] = params[:recp_name] 
  session[:forminfo]['street'] = params[:street] 
  session[:forminfo]['city'] = params[:city]
  session[:forminfo]['state'] = params[:state]
  session[:forminfo]['zip'] = params[:zip]
end
redirect_to cart_path


end



end

