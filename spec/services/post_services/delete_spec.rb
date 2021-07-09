require "rails_helper"

describe "PostServices::Delete" do
  let!(:user) { create(:user, email: "user1@example.com") }
  let!(:post) { create(:post, user: user) }

  context "when the post belongs to current user" do
    let(:service) { PostServices::Delete.new(post.id, user) }

    it do
      expect do
        service.perform
      end.to change(Post, :count).by(-1)
    end
  end

  context "when the post belongs to other user" do
    let(:second_user) { create(:user, email: "user2@example.com") }
    let(:service) { PostServices::Delete.new(post.id, second_user) }

    it do
      expect do
        service.perform
      end.to change(Post, :count).by(0)

      expect(service.errors[:base]).to include("Couldn't find Post with 'id'=#{post.id}")
    end
  end
end
