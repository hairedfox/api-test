class PostSerializer < BaseSerializer
  attributes :title, :body, :user_nickname

  attribute :comments do |obj|
    CommentSerializer.new(obj.comments).serializable_hash[:data]
  end
end
