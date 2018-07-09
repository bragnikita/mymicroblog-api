# == Schema Information
#
# Table name: images_posts
#
#  image_id  :bigint(8)        not null
#  post_id   :bigint(8)        not null
#  link_name :string(255)
#

class ImageOfPost < ApplicationRecord
  self.table_name = :images_posts
  belongs_to :image
  belongs_to :post
end
