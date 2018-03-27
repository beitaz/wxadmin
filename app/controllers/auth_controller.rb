class AuthController < ApplicationController
  skip_before_action :authenticate_user, only: [:index]

  # Public method
  def index
    render json: { service: 'auth#index', status: 200 }
  end

  # Authorized only method
  def authorized
    render json: { status: 200, msg: "You are currently Logged-in as #{current_user.account}" }
  end
end
