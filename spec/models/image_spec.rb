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

require 'rails_helper'

RSpec.describe Image, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
