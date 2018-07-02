class PostContent < ApplicationRecord
  belongs_to :post, class_name: 'Post'
end