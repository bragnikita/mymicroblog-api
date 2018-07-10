require 'rails_helper'

RSpec.describe PostsController, type: :request do

  describe 'index' do
    before(:context) {
      create_list(:post, 5, visability_mode: Post.visability_modes[:visible_public])
      create(:post, visability_mode: Post.visability_modes[:visible_private])
    }
    describe 'fetch all 6 posts' do
      before {
        login
      }

      it 'fetches list of all posts' do
        expected = {
          :items => all(a_hash_including(:id, :title, :excerpt, :published_at))
        }
        get '/posts'

        expect(getBody).to include(expected)
        expect(getBody[:items]).to have(6).items
        expect(response).to have_http_status(200)
      end
    end

    describe 'fetch only public posts' do
      it 'fetches 5 public posts' do
        get '/posts'
        expect(getBody[:items]).to have(5).items
      end
    end


    after {
      logout
    }
  end

  describe 'show' do
    describe 'public post' do
      subject! {
        create(:public_post, title: 'My day')
      }
      it 'should display public post' do
        expected = {
          :object => a_hash_including(:id => anything, :title => 'My day', :body => kind_of(String))
        }
        get "/posts/#{subject.id}"
        expect(getBody).to include(expected)
        expect(response).to have_http_status(200)
      end

      it 'should return 401 if trying to get non-existed post' do
        get "/posts/#{subject.id + 1}"
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'private post' do
      subject! {
        create(:private_post)
      }
      it 'should return 403 if trying to get private post' do
        get "/posts/#{subject.id}"
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'new' do
    it 'should create draft post'
    it 'should return 403 if not authorized'
    it 'should return 401 if trying to get non-existed post'
  end

  describe 'update' do
    it 'should update title and content of the post'
    it 'should return 403 if not authorized'
    it 'should return 401 if trying to get non-existed post'
  end

  describe 'delete' do
    it 'should destroy the post'
    it 'should return 403 if not authorized'
    it 'should return 401 if trying to get non-existed post'
  end

end