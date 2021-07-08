class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, presence: true, length: { minimum: 6, maximum: 255 }
  validates :body, presence: true, length: { minimum: 20, maximum: 3_000 }
end
