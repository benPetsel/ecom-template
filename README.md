# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

https://tailwindcss.com/docs/guides/ruby-on-rails

Using cssbundling-rails gem
https://github.com/rails/cssbundling-rails
used this advice: https://noelrappin.com/blog/2021/09/rails-7-and-javascript/

The devise gem is bing used as the encription solution for logged in owners
* Deployment instructions

* ...
for immidiate styling updates / css rebuilding
 When developing front end:
    Run: 'yarn build:css --watch ' in one terminal
    AND
    Run the server in a seperate terminal.

The shopping functionallity usses sessions and is currently set up as follows:
Session[:carts] is initialised as a hash object -> {}
Next
This object stores the ID as the key and the quantity as the value
IE: {id => quantity , id => quantity} 
this is how the cart keeps track of its contents per user. 
This MAY be updated to store nested hashes IF more than quantity information is needed. 
**This will be based on the session storage limit, but im pretty sure will suffice for a shopping cart. 

looks like shipping is going to use easypost as a solution
the api is now integrated :D 

Stripe API is integrated for payment processing
For stripes webhooks I have integrated the gem 'stripe_event'
at the behest of this tutorial: 
https://dev.to/maxencehenneron/handling-stripe-webhooks-with-ruby-on-rails-4bb7

#TO DO add prices and products to the stripe dashbord programatically 
      # https://stripe.com/docs/products-prices/manage-prices?dashboard-or-api=api
      # this will need to be integrated into the product craetion portal soon.
      # this is also important for more accurate tax collection as Stripe requires a price object 
      #to calculate tax


      FOR ME:: 
      Tut for image uploads- https://levelup.gitconnected.com/rails-image-upload-101-f9bf245e389b
      

      to do:

      

        

        
         LATER - add shipping duration to cart controller stripe shipping create
         THis belongs inside the store controller inside the shipping stripe create action under DISPLAY NAME
         and before METADATA
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

      DONE - FIX visible option to not required
      DONE - !!enviroment variables!!
      DONE -  add shipping description duration to shipment rates
      DONE - seed master pass
      DONE - seed cms
      DONE- configure managements menu
      DONE - remove destroy and edit actions from completed orders    
      DONE - fix pictures on contact page
      DONE - build entire cms in one night like a crackhead 
      DONE - add quick about page
      DONE - secondary_heading
      DONE - add left in stock while veiwing products
      DONE - back to shop button while veiwing products
      DONE - ON SALE add UI 
      DONE - Mobile!! shoping cart items need UI correction
      DONE - no check out with empty cart
      DONE - FOR NOW - package size algorithm 
      DONE style devise logins
      DONE add owner sign in using devise -- tutorial twards bottom -- https://www.honeybadger.io/blog/rails-app-aws-s3/
      DONE user creation ONLY by admins (in this apps case any signed in user is considered an admin)
      DONE clear cart and shipping rates
      DONE collect name and email for orders
      DONE order complete purchases decending 
      DONE fix address collection problem
      DONE -- ad ui elements for - sold out - old price - see more to all products  
      DONE -- contact page 
      DONE -- push to remote git repo 
      DONE decrement number of products after sale 
      DONE done make sure people cant buy more inventory than is avalable !!
      DONE switch item to sold out if database reads 0 quantity
      DONE mobile!! Menu hamburger needs javascript !!! (script now located in _majornav partial. Consider moving) !!!
        
        LATER - controll image upload size
        LATER - visual style with data-aos
        LATER - add home page with featured option?


    MIGHT BE ABLE TO SKIP -- add table to host checkout ids, completed shipping booleen and new bool. 
      The id from this table will look up the corespoding list of matching ids in the completed_orders table

     
      AFTER LAUNCH -- add table for user management data- about text- logo manage - about me photo - Shop text - brand text - FAQ
      add active analitics --- tutorial bootrails -- https://www.bootrails.com/blog/rails-analytics-made-simple/

      reviews.io as possible review system 

      same tut to add amazon buckets for multi picture upload management -- https://www.honeybadger.io/blog/rails-app-aws-s3/

       pixiset - website for photographers can I sell?

DONE -- fix ssl issue
DONE -- product visible remove required
DONE -- delete secondary photo
DONE -- show photos on edit screen
DONE -- pounds to oz for product weight
DONE -- option to show or hide dementions
DONE -- shipping details on compled orders
DONE -- name of person on compled details 
DONE --name of person to mailing checkout. 
DONE -- corrected new product category issue
add change log in logged in 

!!! order of products !!!
gallary 
options for products 
add google reviews??
Add sales tax option?? 

error handling for boxes over 28 inches AND box size inputs for owner. 
fix ecomtemp in tab + image controll for that thing 
    
      

add categories-list to managements
add manipulation of categories-list to management-form via Jquery or js
reference category-list in product edit form to propigate options/category it belongs to
What if something belongs to multiple categories?
Use for.each method on managements categories-list to auto genterate the filter object (allready functional) at the top of the shop page

