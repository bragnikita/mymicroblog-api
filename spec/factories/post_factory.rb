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

FactoryBot.define do
  factory :post do
    sequence :title do |n|
      "Daily ##{n}"
    end
    excerpt "Some short description of this day"
    source_type 1

    after(:create) do |post|
      if post.post_contents.empty?
        post.post_contents << create(:contents, post: post, type: 'body')
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
  end

end
