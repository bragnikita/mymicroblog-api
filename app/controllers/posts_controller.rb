class PostsController < ApplicationController

  before_action :authenticate
  before_action :authorize, :except => [:index, :show]
  before_action :set_post, :only => [:show, :update, :destroy]


  def index
    filter = params[:show] || 'none'
    posts = Post.order(:datetime_of_placement => :desc)
    if authorized?
      posts = posts.not.where(visability_mode: [:draft])
      case filter
        when 'public'
          posts = posts.where(visability_mode: [:visible_public])
        when 'published'
          posts = posts.not.where(visability_mode: [:hidden]).not.where(status: [:draft])
        when 'unpublished'
          posts = posts.where(visability_mode: [:hidden])
        else
          posts = posts
      end
    else
      posts = posts.where(visability_mode: [:public])
      case filter
        when 'public'
        when 'published'
          posts = posts
        else
          raise ApiErrors::Forbidden
      end
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

  def create
    @post = Post.build_empty
    @post.save!
    render json: {object: serialize_post_editing(@post)}, status: :created
  end

  def update
    # @post.update!(post_update_params)
    render json: {object: serialize_post_editing(@post)}, status: :ok
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
      visability_mode: post.visability_mode,
      cover_url: post.cover&.link&.url
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
      visability: post.visability_mode
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