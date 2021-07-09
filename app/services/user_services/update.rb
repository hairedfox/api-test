class UserServices::Update < BaseService
  def initialize(params, current_user)
    @params = params
    @current_user = current_user
    super()
  end

  def perform
    if params[:password]
      update_user!
    else
      update_user_without_password!
    end

    @result = current_user

    self
  rescue StandardError => e
    @errors[:base] = e.message

    self
  end

  private

  def update_user!
    current_user.update!(
      nickname: params[:nickname],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
  end

  def update_user_without_password!
    current_user.update!(nickname: params[:nickname])
  end

  attr_reader :params, :current_user
end
