require 'rails_helper'
# == Schema Information
#
# Table name: post_contents
#
#  id         :bigint(8)        not null, primary key
#  content    :string(255)
#  post_id    :bigint(8)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
RSpec.describe PostContent, type: :model do
  describe "CRUD" do
    subject(:post) {
      create(:contents)
    }

    it "creates post" do
      expect {subject}.to_not raise_error
    end

    it "creates valid content" do
      is_expected.to be_valid
    end

    it "updates post" do
      content = Faker::Lorem.paragraphs(3).join('\n')
      subject.update(content: content)
      subject.reload
      expect(subject.content).to eq(content)
    end

    it "deletes post" do
      expect(subject.destroy).to be_truthy
      expect(PostContent.exists?(subject.id)).to be_falsey
    end
  end

  describe "Associations" do
    subject(:content) {
      create(:contents)
    }

    it "allow access to associations" do
      expect(content.post).to_not be_nil
    end
  end
end
