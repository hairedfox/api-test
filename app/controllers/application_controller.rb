class ApplicationController < ActionController::Base
  include Pagy::Backend

  skip_before_action :verify_authenticity_token

  before_action :authenticate!

  attr_reader :current_user

  def authenticate!
    @current_user = AuthorizeApiRequest.new(request.headers).perform.result
    render json: { error: "Not Authorized" }, status: :unauthorized unless @current_user
  end
end
