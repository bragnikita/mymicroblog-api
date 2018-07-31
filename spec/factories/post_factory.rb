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

FactoryBot.define do
  factory :post do
    sequence :title do |n|
      "Daily ##{n}"
    end
    excerpt "Some short description of this day"
    source_type 1
    status Post.statuses[:published]
    published_at Time.now
    visability_mode Post.visability_modes[:visible_public]
    sequence :slug do |n|
      "/path_#{n}"
    end


    transient {
      images_count 3
      linked_images []
    }

    after(:create) do |post|
      if post.post_contents.empty?
        post.post_contents << create(:contents, post: post, type: 'body_source')
      end
    end

    trait :with_cover do
      after(:create) do |post|
        post.cover = create(:image)
        post.save
      end
    end

    trait :with_images do
      after(:create) do |post, eval|
        if eval.linked_images.empty?
          (1..eval.images_count).each_with_index do |link, index|
            post.images << create(:image)
          end
        else
          eval.linked_images.each_with_index do |link, index|
            post.image_links.create(link_name: link, image: create(:image), index: index)
          end
        end
      end
    end

    factory :public_post do
      visability_mode Post.visability_modes[:visible_public]
    end
    factory :private_post do
      visability_mode Post.visability_modes[:visible_private]
    end
    factory :hidden_post do
      visability_mode Post.visability_modes[:hidden]
    end
  end
  factory :draft, class: Post do
    source_type 1
    visability_mode Post.visability_modes[:hidden]
    status Post.statuses[:draft]
    transient {
      from nil
    }
    after(:create) do |post|
      if post.post_contents.empty?
        post.post_contents << create(:contents, post: post, type: 'body_source')
      end
    end
    after(:build) do |post, eval|
      unless eval.from.nil?
        post.title = eval.from.title
        post.slug = eval.from.slug
        post.excerpt = eval.from.excerpt
        post.cover = eval.from.cover
        post.visability_mode = eval.from.visability_mode
        post.published_at = eval.from.published_at
      end
    end
  end
end
