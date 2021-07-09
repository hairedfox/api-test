class User < ApplicationRecord
  PERMITTED_PARAMS = %i[email password password_confirmation nickname].freeze
  UPDATABLE_PARAMS = %i[password password_confirmation nickname].freeze

  has_many :posts
  has_many :comments, through: :posts

  validates :email, presence: true, email: true
  validates :nickname, presence: true

  has_secure_password
end
