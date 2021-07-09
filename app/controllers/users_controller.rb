class UsersController < ApplicationController
  skip_before_action :authenticate!, only: :create

  def create
    user_service = CreateUser.new(user_params).perform

    return render(json: { error: user_service.errors }, status: :bad_request) unless user_service.result

    user = user_service.result

    service = AuthenticateUser.new(user.email, user.password).perform

    render json: { auth_token: service.result }, status: :ok
  end

  def update
    user_service = UpdateUser.new(user_params, current_user).perform

    return render(json: { error: user_service.errors }, status: :bad_request) if user_service.errors.present?

    render json: {}, status: :ok
  end

  private

  def user_params
    params.permit(*User::PERMITTED_PARAMS)
  end

  def user_update_params
    params.permit(*User::UPDATABLE_PARAMS)
  end
end
