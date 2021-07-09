class Comment < ApplicationRecord
  belongs_to :post

  validates :content, presence: true, length: { minimum: 3, maximum: 255 }

  delegate :user, :user_nickname, to: :post
end
