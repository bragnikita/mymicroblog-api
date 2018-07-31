class PostsController < ApplicationController
  include ::Operations::PostOperations

  before_action :authenticate
  before_action :authorize, :except => [:index, :show]
  before_action :set_post, :only => [:show, :update, :destroy, :update_content, :preview ]


  def index
    selector = PostSelect.for_filter(params)
    unless authorized?
      if params[:show] != 'public'
        raise ApiErrors::Forbidden
      end
    end
    posts = selector.call.result
    render json: {
      items: posts.map {|p| serialize_listing(p)}
    }, status: 200
  end

  def edit
    post = PostEdit.new(id: params[:post_id]).call.result
    render json: {
      object: serialize_post_editing(post)
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
    @post = PostCreate.new.call.result
    render json: {object: serialize_post_editing(@post)}, status: :created
  end

  def update
    op = PostUpdate.new(id: params[:id])
    op.post_attributes = update_post_params if params.key? :post
    op.images = params[:images]
    op.body = params[:body]
    @post = op.call.result
    render json: {object: serialize_post_editing(@post)}, status: :ok
  end

  def update_content
    op = PostUpdate.new(id: @post.id)
    op.body = params[:body]
    op.call
    if params[:preview] == 'preview'
      render status: :ok, html: op.result.body_result.content
    else
      render status: :ok
    end
  end

  def preview
    result = @post.body_result
    if result.nil?
      render status: :not_found
    else
      render status: :ok, html: result.content
    end
  end

  def destroy
    @post.destroy!
    render status: :ok
  end

  def update_attribute
    PostUpdate.new(id: params[:post_id], post_attributes: update_post_params ).call
    render status: :ok
  end

  private

  def update_post_params
    params.require(:post).permit(
      :title, :exceprt, :slug, :published_at, :source_type, :visability_mode, :excerpt, :cover_id
    )
  end

  def set_post
    if params.key? :post_id
      @post = Post.find(params[:post_id])
    elsif params.key? :id
      @post = Post.find(params[:id])
    end
  end

end

def post_update_params
  params.require(:post).permit(:title, :excerpt, :body, :cover, :source_type, :datetime_of_placement, :slug)
end

def serialize_listing(post)
  {
    id: post.id,
    title: post.title,
    excerpt: post.excerpt,
    slug: post.slug,
    status: post.status,
    published_at: post.published_at,
    visability_mode: post.visability_mode,
    cover: post.cover.present? && {id: post.cover.id, url: post.cover.link.url}
  }
end

def serialize_post_read(post)
  {
    id: post.id,
    title: post.title,
    excerpt: post.excerpt,
    published_at: post.published_at,
    cover: post.cover&.link&.url,
    body: serialize_post_body(post),
    visability_mode: post.visability_mode
  }
end

def serialize_post_body(post)
  contents = post.post_contents.where(type: 'body').first
  contents&.content
end

def serialize_post_editing(post)
  json = serialize_listing(post)
  json[:source_type] = post.source_type
  json[:body] = post.body_source.content
  json[:images] = post.image_links.map {|l|
    {
      link: l.link_name,
      id: l.image.id,
      url: l.image.link.url
    }
  }
  json
end