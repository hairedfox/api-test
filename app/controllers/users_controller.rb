class UsersController < ApplicationController
  skip_before_action :authenticate!, only: :create

  def show
    user = User.find(params[:id])

    render_with_serializer(user, :user)
  end

  def create
    user_service = UserServices::Create.new(user_params).perform

    return render_error(user_service) unless user_service.result

    user = user_service.result

    service = AuthenticateUser.new(user.email, user.password).perform

    render json: { auth_token: service.result }, status: :ok
  end

  def update
    user_service = UserServices::Update.new(user_params, current_user).perform

    return render_error(user_service) if user_service.has_error?

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
