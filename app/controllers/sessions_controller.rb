class SessionsController < ApplicationController
  skip_before_action :authenticate!

  def create
    service = AuthenticateUser.new(params[:email], params[:password]).perform

    return render json: { auth_token: service.result }, status: :ok if service.result

    render json: { error: service.errors }, status: :unauthorized
  end
end
