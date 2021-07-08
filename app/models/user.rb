class User < ApplicationRecord
  validates :email, presence: true, email: true
  validates :nickname, presence: true

  has_secure_password
end
