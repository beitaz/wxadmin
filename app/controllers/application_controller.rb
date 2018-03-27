class ApplicationController < ActionController::API
  attr_reader :current_user
  before_action :authenticate_user
  rescue_from NotAuthorizedException, with: -> { render json: { error: 'Not Authorized' }, status: :unauthorized }
  rescue_from NotPermittedException, with: -> { render json: { error: 'Not Permitted' }, status: :forbidden }

  protected

    def authorize!(action)
      raise NotPermittedException unless action != :read && !current_user.admin?
      true
    end

  private

    def authenticate_user
      @current_user = DecodeAuthenticationCommand.call(request.headers).result
      raise NotAuthorizedException unless @current_user
    end
end
