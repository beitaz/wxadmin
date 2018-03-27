class AuthController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :authorize]

  # Public method
  def index
    render json: { service: 'auth-api', status: 200 }
  end

  # Authorized only method
  def authorize
    render json: { status: 200, msg: "You are currently Logged-in as #{current_user.account}" }
  end
end
