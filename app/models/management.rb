class Management < ApplicationRecord
    has_one_attached :logo, :dependent => :destroy
    has_one_attached :about_pic, :dependent => :destroy
end
