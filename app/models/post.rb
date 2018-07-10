# == Schema Information
#
# Table name: posts
#
#  id                    :bigint(8)        not null, primary key
#  title                 :string(255)
#  excerpt               :text(65535)
#  datetime_of_placement :datetime
#  source_type           :integer
#  visability_mode       :integer          default(0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  cover_id              :bigint(8)
#

class Post < ApplicationRecord
  has_many :image_links, class_name: 'ImageOfPost', dependent: :destroy
  has_many :images, class_name: 'Image', through: :image_links
  has_many :post_contents, class_name: 'PostContent'
  belongs_to :cover, class_name: 'Image', optional: true

  enum visability_mode: [:draft, :visible_private, :visible_public]
  enum source_type: [:html, :markdown]

  def self.build_empty
    post = Post.new
    post.post_contents.build(type: 'body')
    post.markdown!
    post.draft!
    post
  end
end
