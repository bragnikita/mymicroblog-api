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
    sequence :slug do |n|
      "/path_#{n}"
    end

    after(:create) do |post|
      if post.post_contents.empty?
        post.post_contents << create(:contents, post: post, type: 'body_src')
      end
    end

    trait :with_cover do
      after(:create) do |post|
        post.cover = build(:image)
      end
    end

    transient {
      images_count 3
    }

    trait :with_images do
      after(:create) do |post, eval|
        post.images << create_list(:image, eval.images_count)
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
  factory :draft do
    source_type 1
    visability_mode Post.visability_modes[:hidden]
    status Post.statuses[:draft]
    transient {
      from nil
    }
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
