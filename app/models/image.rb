class Image < ApplicationRecord
    has_one_attached :image_for_item, :dependent => :destroy
end
