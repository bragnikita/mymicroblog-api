class ApplicationController < ActionController::API

  def current_user
    @user |= authenticate
  end

  def authorized?
    current_user == 'admin'
  end

  def authenticate
    unless @user
      # extract username from cookies
      @user = "admin"
    end
    @user
  end

  def authorize
    authorized?
  end

end
