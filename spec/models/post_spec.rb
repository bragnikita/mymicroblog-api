require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "CRUD" do
    subject(:post) {
      create(:post,
             :visability_mode => Post.visability_modes[:visible_private]
      )}

    it "creates post" do
      expect {subject}.to_not raise_error
    end

    it "creates valid post" do
      is_expected.to be_valid
    end

    it "updates post" do
      excerpt = Faker::Lorem.sentence(2)
      title = Faker::Lorem.sentence(1)
      subject.update(:title => title, :excerpt => excerpt, :visability_mode => Post.visability_modes[:visible_public])
      subject.reload
      expect(subject).to have_attributes(
                           "title" => title,
                           "excerpt" => excerpt,
                           "visability_mode" => "visible_public",
                         )
    end

    it "deletes post" do
      expect(subject.destroy).to be_truthy
      expect(Post.exists?(subject.id)).to be_falsey
    end
  end

  describe "Associations" do
    subject(:post) {
      create(:post, :with_images, :with_cover, :images_count => 2)
    }

    it "creates post" do
      expect {subject}.to_not raise_error
      expect {subject.images}.to_not raise_error
    end

    it "allow access to associations" do
      expect(post.cover).to_not be_nil
      expect(post.images).to have_exactly(2).items
    end
  end
end
