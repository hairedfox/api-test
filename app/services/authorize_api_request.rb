class AuthorizeApiRequest < BaseService
  def initialize(headers = {})
    @headers = headers
    super()
  end

  def perform
    @result = User.find(decoded_auth_token["user_id"]) if decoded_auth_token
    errors[:token] = "Invalid token" unless @result

    self
  end

  private

  attr_reader :headers

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)[:user_id]&.first
  end

  def http_auth_header
    return headers["Authorization"].split(' ').last if headers['Authorization'].present?

    errors[:token] = "Missing token"
    nil
  end
end
