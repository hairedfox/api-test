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

  describe "#index" do
    context "without search params" do
      before do
        create_list(:post, 50, user: user)
        mock_login(user)
        get :index, params: { page: 2 }
      end

      it { expect(response.parsed_body["items"]["data"].size).to eq(20) }
      it { expect(response.parsed_body["pagy"]["page"]).to eq(2) }
      it { expect(response.parsed_body["pagy"]["last"]).to eq(3) }
    end

    context "with params search" do
      let(:second_user) { create(:user) }
      let!(:first_post) { create(:post, user: user, title: "sample title xi", body: "This is a sample body which has enough characters") }
      let!(:second_post) { create(:post, user: second_user, title: "element ix", body: "Another sample with enough characters") }

      before { mock_login(user) }

      describe ".title" do
        let(:params) do
          {
            q: {
              title_cont: "sample"
            }
          }
        end

        before { get :index, params: params }

        it { expect(response.parsed_body["items"]["data"].size).to eq(1) }
        it { expect(response.parsed_body["items"]["data"].first["id"].to_i).to eq(first_post.id) }
      end

      describe ".body" do
        let(:params) do
          {
            q: {
              body_cont: "Another"
            }
          }
        end

        before { get :index, params: params }

        it { expect(response.parsed_body["items"]["data"].size).to eq(1) }
        it { expect(response.parsed_body["items"]["data"].first["id"].to_i).to eq(second_post.id) }
      end

      describe ".user_id" do
        let(:params) do
          {
            q: {
              user_id_eq: user.id
            }
          }
        end

        before { get :index, params: params }

        it { expect(response.parsed_body["items"]["data"].size).to eq(1) }
        it { expect(response.parsed_body["items"]["data"].first["id"].to_i).to eq(first_post.id) }
      end
    end
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
