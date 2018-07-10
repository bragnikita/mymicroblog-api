class ApplicationController < ActionController::API

  rescue_from ApiErrors::Forbidden, with: :forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def current_user
    @user ||= authenticate
  end

  def authorized?
    current_user == 'admin'
  end

  def authenticate
    request.headers['Authorization']
  end

  def authorize
    raise ApiErrors::Forbidden unless authorized?
  end

  private

  def forbidden
    render json: {
      message: 'Authorization required'
    }, status: :forbidden
  end

  def not_found
    render json: {
      message: 'Requested object not found'
    }, status: :not_found
  end
end
