class ApplicationController < ActionController::API
  include Pundit
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from ActiveRecord::RecordNotFound do |exception|
    head 404
  end

  private
    def user_not_authorized
      render json: "You are not authorized to perform this action", status: :unauthorized
    end

end
