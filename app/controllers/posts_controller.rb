class PostsController < ApplicationController

  before_action :authenticate
  before_action :authorize, :except => [:index, :show]
  before_action :set_post, :only => [:show, :update, :destroy]


  def index
    if authorized?
      posts = Post.where(visability_mode: [:visible_private, :visible_public])
                .order(:datetime_of_placement => :desc)
    else
      posts = Post.where(visability_mode: [:visible_public])
                .order(:datetime_of_placement => :desc)
    end
    posts = posts.includes(:cover)
    render json: {
      items: posts.map {|p| serialize_post(p)}
    }, status: 200
  end

  def show
    unless @post.visible_public?
      authorize
    end
    render json: {
      object: serialize_post_read(@post)
    }
  end

  def new
    @post = Post.build_empty
    @post.save!
    render json: serialize_post_editing(@post), status: :created
  end

  def update
    # @post.update!(post_update_params)
    render json: serialize_post_editing(@post), status: :ok
  end

  def destroy
    @post.destroy!
    render status: :ok
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_update_params
    params.require(:post).permit(:title, :excerpt, :body, :cover, :source_type, :datetime_of_placement)
  end

  def serialize_post(post)
    {
      id: post.id,
      title: post.title,
      excerpt: post.excerpt,
      published_at: post.datetime_of_placement,
      cover: post.cover&.link&.url
    }
  end

  def serialize_post_read(post)
    {
      id: post.id,
      title: post.title,
      exceprt: post.excerpt,
      published_at: post.datetime_of_placement,
      cover: post.cover&.link&.url,
      body: serialize_post_body(post),
    }
  end

  def serialize_post_body(post)
    contents = post.post_contents.where(type: 'body').first
    contents&.content
  end

  def serialize_post_editing(post)
    serialize_post_read(post)
  end
end