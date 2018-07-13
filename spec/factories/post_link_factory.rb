# == Schema Information
#
# Table name: post_links
#
#  id      :bigint(8)        not null, primary key
#  slug    :string(255)
#  post_id :bigint(8)
#

FactoryBot.define do
  factory :post_link do
    sequence :slug do |n|
      "post_num_#{n}"
    end

    before(:create) do |link|
      if link.post.nil?
        link.post = create(:post)
      end
    end
  end
end
