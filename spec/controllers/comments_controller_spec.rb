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
end
