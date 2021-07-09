require "rails_helper"

describe "CreatePost" do
  context "when all the params are valid" do
    let(:user) { create(:user) }
    let(:params) do
      {
        title: "Sample Title",
        body: "Sample Body with over 20 characters"
      }
    end

    let(:service) { CreatePost.new(params, user) }

    it do
      expect do
        service.perform
      end.to change(Post, :count).by(1)

      post = Post.last

      expect(post.title).to eq("Sample Title")
      expect(post.body).to eq("Sample Body with over 20 characters")
    end
  end
end
