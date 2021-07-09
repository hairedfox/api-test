require "rails_helper"

describe "CommentServices::Delete" do
  let!(:user) { create(:user, email: "user1@example.com") }
  let!(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, user: user, post: post) }

  context "when the comment belongs to current user" do
    let(:service) { CommentServices::Delete.new(comment.id, user) }

    it do
      expect do
        service.perform
      end.to change(Comment, :count).by(-1)
    end
  end

  context "when the comment belongs to other user" do
    let(:second_user) { create(:user, email: "user2@example.com") }
    let(:service) { CommentServices::Delete.new(comment.id, second_user) }

    it do
      expect do
        service.perform
      end.to change(Comment, :count).by(0)

      expect(service.errors[:base]).to include("Couldn't find Comment with 'id'=#{comment.id}")
    end
  end
end
