class User < ApplicationRecord
  has_many :posts
  has_many :comments, through: :posts

  validates :email, presence: true, email: true
  validates :nickname, presence: true

  has_secure_password
end