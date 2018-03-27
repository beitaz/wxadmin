class ApplicationController < ActionController::API
  # protect_from_forgery with: :null_session
  include Knock::Authenticable
  before_action :authenticate_user
  rescue_from ActiveRecord::RecordNotFound, with: :error_handler

  # Refresh the JWT to a new 24h token
  def new_jwt
    Knock::AuthToken.new(payload: { sub: current_user.id }).token
  end

  # 重写 rails 的 render 方法,以确保每个 request 请求都发送一个新的 token
  def render(options = nil, extra_options = {}, &block)
    options ||= {}
    # If the user is logged in and we're returning a json object,
    # send a new JWT with it
    options[:json][:jwt] = new_jwt if options[:json].is_a?(Hash) && current_user.present?
    super(options, extra_options, &block)
  end

  # protected

  #   def authorize_admin
  #     debugger
  #     return_unauthorized unless current_user&.admin?
  #   end

  private

    def error_handler(e)
      json = Helpers::Render.json(:record_not_found, e.to_s)
      render json: json, status: 404
    end
end
