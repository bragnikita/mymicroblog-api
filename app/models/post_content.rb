# == Schema Information
#
# Table name: post_contents
#
#  id         :bigint(8)        not null, primary key
#  content    :string(255)
#  post_id    :bigint(8)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PostContent < ApplicationRecord
  PostContent.inheritance_column = 'post_content_type'
  belongs_to :post, class_name: 'Post'
end
