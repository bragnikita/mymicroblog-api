require 'rails_helper'

def be_post_for_editing
  a_hash_including(
    :id, :title, :excerpt, :slug, :published_at,
    :source_type, :visability_mode, :cover, :body, :status => 'draft'
  )
end

def be_post_for_listing
  a_hash_including(
    :id, :title, :excerpt, :slug, :status, :published_at, :visability_mode,
    :cover
  )
end

def be_post_for_display
  a_hash_including(
    :id, :title, :excerpt, :slug, :status, :published_at, :visability_mode,
    :cover, :body
  )
end

RSpec.describe PostsController, type: :request do


  describe 'index' do
    before(:context) {
      create_list(:public_post, 6)
    }
    describe 'fetch all 6 posts' do
      before {
        login
      }

      it 'fetches list of all posts' do
        expected = {
          :items => all(be_post_for_listing)
        }
        get '/posts'

        expect(getBody).to include(expected)
        expect(getBody[:items]).to have(6).items
        expect(response).to have_http_status(200)
      end
    end

    describe 'unauthorized' do
      it 'fetches public posts' do
        get '/posts?show=public'
        expect(response).to have_http_status(200)
      end
      it 'gets 403 error' do
        get '/posts'
        expect(response).to have_http_status(403)
      end
    end


  end

  describe "/posts/:id/edit" do
    describe "if post exists" do
      let(:target) {
        create(:post, :with_cover, :with_images,
               title: 'My day',
               excerpt: 'Long long time ago',
               published_at: Time.new(2007, 11, 19, 8, 37, 48, "-06:00"),
               visability_mode: Post.visability_modes[:visible_public]
        )
      }
      before {
        login
      }
      it 'fetches post to edit' do
        get "/posts/#{target.id}/edit"
        expect(response).to have_http_status(200)
        expect(getBody[:object]).to be_post_for_editing
      end
      it 'returns expected parametes' do
        get "/posts/#{target.id}/edit"
        expect(getBody[:object]).to a_hash_including({
                                                       :id => be_a(Numeric),
                                                       :title => target.title,
                                                       :excerpt => target.excerpt,
                                                       :published_at => '2007-11-19T14:37:48.000Z',
                                                       :cover => a_hash_including(:id, :url),
                                                       :visability_mode => 'visible_public',
                                                       :body => be_a(String),
                                                       :images => all(
                                                         a_hash_including(:id, :url, :link)
                                                       ).and(have(3).items)
                                                     })
      end
    end

    describe "if post not exists" do
      before {
        login
      }
      it 'fetches post to edit' do
        get "/posts/-1/edit"
        expect(response).to have_http_status(:not_found)
      end
    end
    describe "if unauthorized" do
      it 'gets 403 error' do
        get '/posts/1/edit'
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "POST /posts" do
    describe "returns new post" do
      before {
        login
      }
      it 'should return empty post' do
        post '/posts'
        expect(response).to have_http_status(201)
        expect(getBody[:object]).to be_post_for_editing
      end
    end
    describe "if unauthorized" do
      it 'gets 403 error' do
        post '/posts'
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "PATCH /posts/:id" do
    describe "attributes passed" do
      let(:target) {
        create(:draft)
      }
      let(:images) {
        create_list(:image, 2)
      }
      let(:body) {
        "new body"
      }
      let(:cover) {
        create(:image)
      }
      before {
        login
      }
      before {
        patch "/posts/#{target.id}", params: {
          post: {
            title: 'New Title',
            excerpt: 'New excerpt',
            slug: '/new_slug',
            published_at: Time.new(2007, 11, 19, 8, 37, 48, "-06:00"),
            source_type: 'markdown',
            visability_mode: 'visible_public',
            cover_id: cover.id,
          },
          images: images.map {|i| {image_id: i.id}},
          body: body
        }
      }
      subject { getBody[:object] }
      it "should update post attributes" do
        is_expected.to be_post_for_editing
        is_expected.to a_hash_including(
                         {
                           title: 'New Title',
                           excerpt: 'New excerpt',
                           slug: '/new_slug',
                           cover: be_present
                         })
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PUT /posts/:id/content/:preview" do
    let(:target) {
      create(:post)
    }

    before {
      login
    }

    it "should update post's content" do
      put "/posts/#{target.id}/content", params: { body: "new content" }

      expect(response).to have_http_status(200)
    end

    it "should return preview" do
      put "/posts/#{target.id}/content/preview", params: { body: "new content" }

      expect(response).to have_http_status(200)
      expect(response.body).not_to be_blank
    end
  end

  describe "GET /posts/:id/preview" do
    before {
      login
    }
    let(:target) {
      post = create(:post)
      create(:contents, type: 'body_result', content: 'result content', post: post)
      post
    }
    it "should return transformed content" do
      get "/posts/#{target.id}/preview"

      expect(response).to have_http_status(200)
      expect(response.body).to eq('result content')
    end
  end

  describe 'delete' do
    it 'should destroy the post'
    it 'should return 403 if not authorized'
    it 'should return 401 if trying to get non-existed post'
  end

  after {
    logout
  }

end