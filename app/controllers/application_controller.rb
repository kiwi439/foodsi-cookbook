class ApplicationController < ActionController::API
  include Graphiti::Rails::Responders

  rescue_from StandardError do |error|
    unless Rails.env.production?
      render json: { errors: [{ message: error.message, backtrace: error.backtrace }] }, status: :internal_server_error
    else
      render json: { errors: [{ message: 'Something went wrong! Please try again later.' }] }, status: :internal_server_error
    end
  end

  rescue_from ActiveRecord::RecordNotFound, Graphiti::Errors::RecordNotFound do |error|
    render json: {
      errors: [
        {
          status: "404",
          title: "Not Found",
          detail: error.message,
          code: "not_found"
        }
      ]
    }, status: :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |error|
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  # Mock authentication
  def authenticate_user!
    render json: { errors: ['Unauthorized'] }, status: 401 unless current_user
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end
end
