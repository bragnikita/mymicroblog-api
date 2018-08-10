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
  sequence :image_id_sec do |n|
    "#{n}"
  end
  factory :image do
    name { "illust_#{generate(:image_id_sec)}" }
    title {
      "Wonderful photo #{name}"
    }
    type :illustration

    transient {
      image_path 'common.jpg'
    }

    link {
      File.open(Rails.root.join('spec', 'fixtures', 'images', image_path))
    }

    factory :common_image do
      type 'common'
    end

  end
end

