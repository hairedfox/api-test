require "rails_helper"

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:post_obj) { create(:post, user: user) }
  let(:serializable_post) { PostSerializer.new(post_obj).serializable_hash }
  let(:service_struct) { Struct.new(:result, :errors) }
  let(:params) do
    {
      title: post_obj.title,
      body: post_obj.body
    }
  end

  describe "#show" do
    before do
      mock_login(user)
      get :show, params: { id: post_obj.id }
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body[:data]).to eq(serializable_post["data"]) }
  end

  describe "#create" do
    context "when all the params are valid" do
      before do
        mock_login(user)
        allow_any_instance_of(CreatePost).to receive(:perform).and_return(service_struct.new(post_obj, {}))
        post :create, params: params
      end

      it { expect(response.parsed_body[:data]).to eq(serializable_post["data"]) }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when there are errors" do
      before do
        mock_login(user)
        allow_any_instance_of(CreatePost).to receive(:perform).and_return(service_struct.new(nil, { errors: { some_error: "message" } }))
        post :create, params: params
      end

      it { expect(response).to have_http_status(:bad_request) }
    end
  end

  describe "#update" do
    context "when all the params are valid" do
      let(:post) { create(:post, title: "Sample Title", body: "Some sample for the body with 20 or more chars", user: user) }

      let(:params) do
        {
          id: post.id,
          title: "Different Title",
          body: "Another sample body for a valid post"
        }
      end

      before do
        mock_login(user)
        allow_any_instance_of(UpdatePost).to receive(:perform).and_return(service_struct.new(nil, {}))
        put :update, params: params
      end

      it { expect(response.parsed_body[:data]).to eq(serializable_post["data"]) }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when user update other's posts" do
      let(:second_user) { create(:user) }
      let(:post) { create(:post, title: "Sample Title", body: "Some sample for the body with 20 or more chars", user: user) }

      let(:params) do
        {
          id: post.id,
          title: "Different Title",
          body: "Another sample body for a valid post"
        }
      end

      before do
        mock_login(second_user)
        allow_any_instance_of(UpdatePost).to receive(:perform).and_return(service_struct.new(nil, {base: "Couldn't find Post with 'id'=#{post.id}"}))
        put :update, params: params
      end

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.parsed_body["error"]).to eq({ "base" => "Couldn't find Post with 'id'=#{post.id}"}) }
    end
  end

  describe "#delete" do
    let(:user) { create(:user, email: "user1@example.com") }
    let(:post) { create(:post, user: user) }

    context "when users delete their own posts" do
      before do
        mock_login(user)
        allow_any_instance_of(DeletePost).to receive(:perform).and_return(service_struct.new(nil, {}))
        delete :destroy, params: { id: post.id }
      end

      it { expect(response).to have_http_status(:ok) }
    end

    context "when users delete other posts" do
      let(:second_user) { create(:user, email: "user2@example.com") }

      before do
        mock_login(second_user)
        allow_any_instance_of(DeletePost).to receive(:perform).and_return(service_struct.new(nil, {base: "Couldn't find Post with 'id'=#{post.id}"}))
        delete :destroy, params: { id: post.id }
      end

      it { expect(response).to have_http_status(:bad_request) }
    end
  end
end
