# == Schema Information
#
# Table name: posts
#
#  id               :bigint(8)        not null, primary key
#  title            :string(255)
#  excerpt          :text(65535)
#  slug             :string(255)
#  status           :integer          default("draft")
#  published_at     :datetime
#  source_type      :integer
#  visability_mode  :integer          default("hidden")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  original_post_id :bigint(8)
#  cover_id         :bigint(8)
#

class Post < ApplicationRecord
  has_many :image_links, class_name: 'ImageOfPost', dependent: :destroy, autosave: true
  has_many :images, class_name: 'Image', through: :image_links
  has_many :post_contents, class_name: 'PostContent'
  belongs_to :cover, class_name: 'Image', optional: true
  belongs_to :original_post, class_name: 'Post', optional: true
  has_one :post_link, class_name: 'PostLink'

  validates :slug, uniqueness: { scope: :status }, presence: true,
            unless: Proc.new { |p| p.draft?}
  validates :status, presence: true
  validates :visability_mode, presence: true
  validates :source_type, presence: true

  enum visability_mode: [:hidden, :visible_private, :visible_public]
  enum status: [:draft, :published]
  enum source_type: [:html, :markdown]

  def self.build_empty
    post = Post.new(title: '', excerpt: '')
    post.post_contents.build(type: 'body')
    post.markdown!
    post.draft!
    post
  end

  def self.today_posts
    Post.where("DATE(created_at) = DATE(NOW())")
  end

  def body_source
    self.post_contents.find_by(type: 'body_source')
  end

  def body_result
    self.post_contents.find_by(type: 'body_result')
  end

  def build_body_result(params = {})
    self.post_contents.build(params.merge(type: 'body_result'))
  end

end
