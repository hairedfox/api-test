class CommentSerializer < BaseSerializer

  attribute :content
  attribute :author_nickname do |obj|
    obj.user_nickname
  end
end
