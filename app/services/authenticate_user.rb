class AuthenticateUser < BaseService
  def initialize(email, password)
    @email = email
    @password = password
    super()
  end

  def perform
    @result = JsonWebToken.encode(user_id: user.id) if user
    self
  end

  private

  attr_reader :email, :password

  def user
    user = User.find_by(email: email)

    return user if user && user.authenticate(password)

    errors[:user_authentication] = "invalid credentials"
    nil
  end
end
