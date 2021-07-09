require "rails_helper"

describe "CommentServices::Create" do
  let(:user) { create(:user, email: "user1@example.com", nickname: "User1") }
  let(:second_user) { create(:user, email: "user2@example.com", nickname: "User2") }
  let(:post) { create(:post, user: user) }

  context "when the post is present and the comment is valid" do
    let(:service) { CommentServices::Create.new({ post_id: post.id, content: "Sample comment" }, user) }

    it do
      expect do
        service.perform
      end.to change(Comment, :count).by(1)

      comment = Comment.last

      expect(comment.content).to eq("Sample comment")
      expect(comment.user).to eq(user)
      expect(comment.post).to eq(post)
    end
  end

  context "when comment on other's posts" do
    let(:service) { CommentServices::Create.new({ post_id: post.id, content: "Sample comment" }, second_user) }

    it do
      expect do
        service.perform
      end.to change(Comment, :count).by(1)

      comment = Comment.last

      expect(comment.content).to eq("Sample comment")
      expect(comment.user).to eq(second_user)
      expect(comment.post).to eq(post)
    end
  end
end
