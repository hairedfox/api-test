require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user, email: "user1@example.com") }
  let!(:post_obj) { create(:post, user: user) }
  let(:service_struct) { Struct.new(:result, :errors) }

  describe "#create" do
    context "when the content is valid" do
      before do
        mock_login(user)
        allow_any_instance_of(CreateComment).to receive(:perform).and_return(service_struct.new(nil, {}))
        post :create, params: { post_id: post_obj.id, content: "Sample comment" }
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end

  describe "#update" do
    let(:user) { create(:user, email: "user1@example.com") }
    let(:second_user) { create(:user, email: "user2@example.com") }
    let(:post) { create(:post, user: user) }
    let(:comment) { create(:comment, user: user, post: post) }

    context "when the content is valid and the user owns the comment" do
      before do
        mock_login(user)
        allow_any_instance_of(UpdateComment).to receive(:perform).and_return(service_struct.new(nil, {}))
        put :update, params: { post_id: post.id, id: comment.id, content: "Just test the comment" }
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context "when user tries to edit other's comment" do
      before do
        mock_login(user)
        allow_any_instance_of(UpdateComment).to receive(:perform).and_return(service_struct.new(nil, { base: "error message" }))
        put :update, params: { post_id: post.id, id: comment.id, content: "Just test the comment" }
      end

      it { expect(response).to have_http_status(:bad_request) }
    end
  end

  describe "#destroy" do
    let(:user) { create(:user, email: "user1@example.com") }
    let(:second_user) { create(:user, email: "user2@example.com") }
    let(:post) { create(:post, user: user) }
    let!(:comment) { create(:comment, user: user, post: post) }

    context "when users delete their own comments" do
      before do
        mock_login(user)
        allow_any_instance_of(DeleteComment).to receive(:perform).and_return(service_struct.new(nil, {}))
        delete :destroy, params: { post_id: post.id, id: comment.id }
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context "when users delete other's comment" do
      before do
        mock_login(user)
        allow_any_instance_of(DeleteComment).to receive(:perform).and_return(service_struct.new(nil, { base: "some error" }))
        delete :destroy, params: { post_id: post.id, id: comment.id }
      end

      it { expect(response).to have_http_status(:bad_request) }
    end
  end
end
