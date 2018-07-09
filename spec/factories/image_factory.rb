# == Schema Information
#
# Table name: images
#
#  id         :bigint(8)        not null, primary key
#  link       :string(255)
#  name       :string(255)
#  title      :string(255)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :image do
    sequence :name do |n|
      "illust_#{n}"
    end
    title {
      "Wonderful photo #{name}"
    }
    type :illustration
  end
end

