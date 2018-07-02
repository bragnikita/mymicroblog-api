class Post < ApplicationRecord
  has_many :image_links, class_name: 'ImageOfPost', dependent: :destroy
  has_many :images, class_name: 'Image', through: :image_links
  has_many :post_contents, class_name: 'PostContent'
  belongs_to :cover, class_name: 'Image'
end