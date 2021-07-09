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

  describe "#create" do
    context "when all the params are valid" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:authenticate!).and_return(true)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        allow_any_instance_of(CreatePost).to receive(:perform).and_return(service_struct.new(post_obj, {}))
        post :create, params: params
      end

      it { expect(response.parsed_body[:data]).to eq(serializable_post["data"]) }
      it { expect(response).to have_http_status(:ok) }
    end

    context "when there are errors" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:authenticate!).and_return(true)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        allow_any_instance_of(CreatePost).to receive(:perform).and_return(service_struct.new(nil, { errors: { some_error: "message" } }))
        post :create, params: params
      end

      it { expect(response).to have_http_status(:bad_request) }
    end
  end
end
