class ImageOfPost < ApplicationRecord
  self.table_name = :images_posts
  belongs_to :image
  belongs_to :post
end