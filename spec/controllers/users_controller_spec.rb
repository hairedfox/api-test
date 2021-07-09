require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user, email: "hai@example.com", password: "Password1@", password_confirmation: "Password1@") }
  let(:serializable_hash) { UserSerializer.new(user).serializable_hash }
  let(:service_struct) { Struct.new(:result, :errors, :has_error?) }

  describe "#show" do
    before do
      mock_login(user)
      get :show, params: { id: user.id }
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body[:data]).to eq(serializable_hash["data"]) }
  end

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
      let(:service) { service_struct.new("some_token", {}, false) }

      before do
        allow_any_instance_of(AuthenticateUser).to receive(:perform).and_return(service)
        post :create, params: params
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(response.parsed_body).to eq({ auth_token: "some_token" }.with_indifferent_access) }
      it { expect(User.count).to eq(1) }
    end
  end

  describe "#update" do
    let(:params) do
      {
        password: "password",
        password_confirmation: "password",
        nickname: "HAREFX"
      }
    end

    context "when the params includes the password" do
      before do
        mock_login(user)
        allow_any_instance_of(UserServices::Update).to receive(:perform).and_return(service_struct.new(nil, {}, false))
        patch :update, params: params
      end

      it { expect(response).to have_http_status(:ok) }
    end
  end
end
