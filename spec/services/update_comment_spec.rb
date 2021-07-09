require "rails_helper"

describe "UpdateComment" do
  let(:user) { create(:user, email: "user1@example.com", nickname: "User1") }
  let(:second_user) { create(:user, email: "user2@example.com", nickname: "User2") }
  let(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, post: post, user: user, content: "Sample comment 1") }

  context "when users edit their comment" do
    let(:service) { UpdateComment.new({ post_id: post.id, id: user.id, content: "Sample comment 2" }, user) }

    it do
      expect do
        service.perform
      end.to change(Comment, :count).by(0)

      comment = Comment.last

      expect(comment.reload.content).to eq("Sample comment 2")
    end
  end

  context "when users edit other's comment" do
    let(:service) { UpdateComment.new({ post_id: post.id, id: user.id, content: "Sample comment 2" }, second_user) }

    it do
      expect do
        service.perform
      end.to change(Comment, :count).by(0)

      comment = Comment.last

      expect(comment.reload.content).to eq("Sample comment 1")
      expect(service.errors[:base]).to include("Couldn't find Comment")
    end
  end
end
