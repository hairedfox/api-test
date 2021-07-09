class ApplicationController < ActionController::Base
  include Pagy::Backend

  skip_before_action :verify_authenticity_token

  before_action :authenticate!

  rescue_from JWT::DecodeError, with: :render_unauthorized

  attr_reader :current_user

  def authenticate!
    @current_user = AuthorizeApiRequest.new(request.headers).perform.result
    render_unauthorized unless @current_user
  end

  def render_unauthorized
    render json: { error: "Not Authorized" }, status: :unauthorized
  end

  def render_error(service, error_code = :bad_request)
    render json: { error: service.errors }, status: error_code
  end

  def render_with_serializer(data, serializer_sym)
    serializer_klass = "#{serializer_sym.to_s.capitalize}Serializer".constantize
    data_to_render = serializer_klass.new(data).serializable_hash

    render json: data_to_render, status: :ok
  end
end
