class UserServices::Create < BaseService
  def initialize(params = {})
    @params = params
    super()
  end

  def perform
    @result = User.create!(
      email: params[:email],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      nickname: params[:nickname]
    )

    self
  rescue StandardError => e
    @errors[:base] = e.message

    self
  end

  private

  attr_reader :params
end
