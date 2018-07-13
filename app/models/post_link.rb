# == Schema Information
#
# Table name: post_links
#
#  id      :bigint(8)        not null, primary key
#  slug    :string(255)
#  post_id :bigint(8)
#

class PostLink < ApplicationRecord
  belongs_to :post, class_name: 'Post'
  validates :slug, uniqueness: true

end
