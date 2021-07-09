require "rails_helper"

describe "PostServices::Update" do
  let!(:user) { create(:user, email: "user1@example.com") }
  let!(:post) { create(:post, title: "Initial Title", body: "Sample Body with over 20 characters", user: user) }
  let(:params) do
    {
      id: post.id,
      title: "Sample Title",
      body: "Another Sample Body with over 20 characters"
    }
  end

  context "when all the params are valid" do
    let(:service) { PostServices::Update.new(params, user) }

    it do
      expect do
        service.perform
      end.to change(Post, :count).by(0)

      expect(post.reload.title).to eq("Sample Title")
      expect(post.reload.body).to eq("Another Sample Body with over 20 characters")
    end
  end

  context "when users try to update other's posts" do
    let(:second_user) { create(:user, email: "user2@example.com") }
    let(:service) { PostServices::Update.new(params, second_user) }

    it do
      expect do
        service.perform
      end.to change(Post, :count).by(0)

      expect(service.errors[:base]).to include("Couldn't find Post")
      expect(post.reload.title).to eq(post.title)
      expect(post.reload.body).to eq(post.body)
    end
  end
end
