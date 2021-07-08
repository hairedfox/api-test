require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "#create" do
    let(:params) do
      {
        email: "hai@example.com",
        password: "password",
        password_confirmation: "password",
        nickname: "HAREFX"
      }
    end

    context "when all the params are valid" do
      let(:auth) { Struct.new(:result, :errors) }
      let(:service) { auth.new("some_token", {}) }

      before do
        allow_any_instance_of(AuthenticateUser).to receive(:perform).and_return(service)
        post :create, params: params
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to eq({ auth_token: "some_token" }.with_indifferent_access) }
      it { expect(User.count).to eq(1) }
    end
  end
end
