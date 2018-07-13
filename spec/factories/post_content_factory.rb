# == Schema Information
#
# Table name: post_contents
#
#  id         :bigint(8)        not null, primary key
#  content    :text(65535)
#  post_id    :bigint(8)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :contents, class: PostContent do
    content Faker::Lorem.paragraph
    type "text"
    association :post, factory: :post
  end
end
