class UserSerializer < BaseSerializer
  attributes :email, :nickname

  attribute :posts do |obj|
    PostSerializer.new(obj.posts).serializable_hash[:data]
  end
end
