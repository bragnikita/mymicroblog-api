# == Schema Information
#
# Table name: posts
#
#  id               :bigint(8)        not null, primary key
#  title            :string(255)
#  excerpt          :text(65535)
#  slug             :string(255)
#  status           :integer          default("draft")
#  published_at     :datetime
#  source_type      :integer
#  visability_mode  :integer          default("hidden")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  original_post_id :bigint(8)
#  cover_id         :bigint(8)
#

require 'rails_helper'
require 'database_cleaner'

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

  describe "Methods" do
    describe "self.today_posts" do
      # before {
      #   DatabaseCleaner.strategy = :truncation
      #   DatabaseCleaner.clean
      # }
      before {
        # assert Post.count == 0
        create_list(:post, 2)
        yesterday_post = build(:post)
        yesterday_post.created_at = Date.yesterday
        yesterday_post.save
      }
      it "should select 2 posts" do
        expect(Post.today_posts).to have(2).items
      end
    end
  end
end
