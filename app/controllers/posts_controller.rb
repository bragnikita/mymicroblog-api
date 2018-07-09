class PostsController < ApplicationController

  before_action :authenticate
  before_action :authorize_admin, :except => [:index, :show]


  def index
    if authorized?
      posts = Posts.where(visability_mode: [:visible_private, :visible_public])
        .order(:datetime_of_placement => :desc)
    else
      posts = Posts.where(visability_mode: [:visible_public])
        .order(:datetime_of_placement => :desc)
    end

  end


end