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

  end

end
