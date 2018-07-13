# == Schema Information
#
# Table name: post_links
#
#  id      :bigint(8)        not null, primary key
#  slug    :string(255)
#  post_id :bigint(8)
#

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "CRUD" do
    let(:new_post) {
      create(:post)
    }
    subject(:link) {
      create(:post_link)
    }

    it "creates link with post" do
      expect { subject }.to_not raise_error
    end

    it "creates valid link" do
      is_expected.to be_valid
    end

    it "sets new post to link" do
      subject.post = new_post
      expect { subject.save }.to_not raise_error
    end

  end

end
