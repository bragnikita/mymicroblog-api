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

  describe "CRUD" do

    subject(:image) { create(:common_image, image_path: 'common.jpg') }

    it "must create and save common image" do
      expect { subject }.not_to raise_error
    end

    it "must upload file to /images/common/:id" do
      expect(File.exists?(Rails.root.join('public/uploads/images/common', "#{subject.id.to_s}", "common.jpg"))).to be_truthy
    end

    after do
      removeFile(subject)
    end

  end

  after(:all) do
    FileUtils.rm_r Dir.glob(Rails.root.join('public/uploads/images/', '*'))
  end

end

def removeFile(image)
  if image
    image.remove_link!
    image.save
  end
end