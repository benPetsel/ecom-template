class Product < ApplicationRecord
    has_one_attached :image, :dependent => :destroy
    has_one_attached :secondary_image, :dependent => :destroy
end
