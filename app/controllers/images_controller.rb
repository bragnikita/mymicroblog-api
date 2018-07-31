class ImagesController < ApplicationController
  include ::Operations::ImageOperations
  include ::Policies::Posting

  before_action :authenticate
  before_action :authorize, :except => [:get_post_images]

  def create
    res = ImageUpload.new(new_image_params[:file]).call.result
    render json: {
      object: {
        id: res.id,
        url: res.link.url
      }
    }, status: :created
  end

  def create_and_attach_post
    res = ImageUploadForPost.new(post_id: params[:post_id],
                                 link: post_params[:link],
                                 file: new_image_params[:file]).call.result
    render json: {
      object: {
        id: res.id,
        url: res.link.url
      }
    }, status: :created
  end

  def get_post_images
    json = []
    posts = Post.find(params[:post_id])
    unless authorized?
      raise ApiErrors::Forbidden unless PublicView.new(post: posts).allowed?
    end
    Post.find(params[:post_id]).image_links.includes(:image).order(:index => :asc).each do |link|
      json << {
        link_id: link.id,
        image_id: link.image.id,
        url: link.image.link.url,
        index: link.index,
        link_name: link.link_name
      }
    end
    render json: {
      items: json
    }, status: :ok
  end

  private

  def new_image_params
    params.require(:image).permit(:file)
  end

  def post_params
    params.require(:post).permit(:id, :link)
  end
end