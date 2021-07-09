require "rails_helper"

describe "UpdatePost" do
  context "when all the params are valid" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, title: "Initial Title", body: "Sample Body with over 20 characters", user: user) }
    let(:params) do
      {
        id: post.id,
        title: "Sample Title",
        body: "Another Sample Body with over 20 characters"
      }
    end

    let(:service) { UpdatePost.new(params, user) }

    it do
      expect do
        service.perform
      end.to change(Post, :count).by(0)

      expect(post.reload.title).to eq("Sample Title")
      expect(post.reload.body).to eq("Another Sample Body with over 20 characters")
    end
  end
end
