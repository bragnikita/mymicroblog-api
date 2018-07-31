# == Schema Information
#
# Table name: images_of_posts
#
#  id        :bigint(8)        not null, primary key
#  image_id  :bigint(8)
#  post_id   :bigint(8)
#  link_name :string(255)
#  index     :integer
#

class ImageOfPost < ApplicationRecord
  self.table_name = :images_of_posts
  belongs_to :image, class_name: 'Image'
  belongs_to :post, class_name: 'Post'
end
