class ApplicationController < ActionController::API
  include Knock::Authenticable
  before_action :authenticate_user

  protected

    def authorize_admin
      return_unauthorized unless current_user&.admin?
    end
end
