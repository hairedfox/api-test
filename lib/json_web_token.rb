class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, ENV["JWT_SECRET"])
    end

    def decode(token)
      body = JWT.decode(token, ENV["JWT_SECRET"])
      HashWithIndifferentAccess.new(body)
    end
  end
end
