require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "#create" do
    let(:service) do
      Auth = Struct.new(:result, :errors)

      Auth.new("some_token", {})
    end

    before do
      allow_any_instance_of(AuthenticateUser).to receive(:perform).and_return(service)

      post :create, params: { email: "hai@example.com", password: "password" }
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(response.parsed_body).to eq({ auth_token: "some_token" }.with_indifferent_access)}
  end
end
