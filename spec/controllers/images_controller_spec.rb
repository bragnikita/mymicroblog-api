require 'rails_helper'

RSpec.describe ImagesController, type: :request do

  describe 'POST /images' do
    before {
      login
    }
    describe 'when new image uploaded' do
      let(:file) {
        fixture_file_upload('images/common.jpg', 'image/jpg')
      }

      it 'expected to return image id and url' do
        post '/images/', params: {image: {file: file}}

        expect(response).to have_http_status(:created)
        expect(getBody).to include(
                             :object => a_hash_including(
                               :id => anything,
                               :url => include("common.jpg")
                             )
                           )
      end
    end
  end

  describe 'POST /posts/:post_id/images/' do
    before {
      login
    }
    describe 'when new image uploaded during post editing' do
      let(:target) {
        create(:draft)
      }
      let(:file) {
        fixture_file_upload('images/common.jpg', 'image/jpg')
      }
      let(:link) { 'cover' }
      let(:image_link) {
        Post.find(target.id).image_links.first
      }
      before {
        post "/posts/#{target.id}/images", params: {
          image: {
            file: file
          },
          post: {
            link: link
          }
        }
      }
      it 'expected to return image id and url' do
        expect(response).to have_http_status(:created)
        expect(getBody).to include(
                             :object => a_hash_including(
                               :id => anything,
                               :url => include("common.jpg")
                             )
                           )
      end

      it 'expected to image to be linked to the post' do
        expect(image_link).not_to be_nil
        expect(image_link).to have_attributes(:link_name => 'cover')
        expect(image_link.image.link.url).to include("common.jpg")
      end
    end
  end

  describe "GET /posts/:post_id/images" do
    before {
      logout
    }

    let(:target) { create(:post, :with_images , linked_images: %w{ illust1 illust2 illust3}) }

    before {
      get "/posts/#{target.id}/images"
    }

    subject {
      getBody[:items]
    }

    it "expected to return all attached images" do
      expect(subject).to have(3).items
      expect(subject).to all(a_hash_including(
                               :link_id => anything,
                               :image_id => anything,
                               :url => kind_of(String),
                               :index => kind_of(Numeric),
                               :link_name => kind_of(String)
                             ))
      expect(subject.map { |i| i[:link_name]} ).to contain_exactly('illust1', 'illust2', 'illust3')
      expect(subject.map { |i| i[:link_name]} ).to eq(['illust1', 'illust2', 'illust3'])
    end
  end
end