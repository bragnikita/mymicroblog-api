class DeveloperController < ApplicationController

  def list_all_posts
    posts = []
    Post.order(:updated_at => :desc).each_with_index do |post, index|
      posts << {
        index: index,
        id: post.id,
        title: post.title,
        status: post.status,
        updated_at: post.updated_at
      }
    end

    render json: {
      count: posts.length,
      items: posts
    }
  end

end