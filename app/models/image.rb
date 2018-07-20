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

class Image < ApplicationRecord
  Image.inheritance_column = 'image_type'
  mount_uploader :link, ImageUploader

  after_initialize :set_defaults

  private

  def set_defaults
    self.type = 'common' if self.type.nil?
  end

end
