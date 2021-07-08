require "rails_helper"

describe "AuthenticateUser" do
  let(:user) { create(:user) }

  context "when the credentials are valid" do
    let(:service) { AuthenticateUser.new(user.email, user.password) }

    before { service.perform }

    it { expect(service.result).to be_present }
    it { expect(service.result).to be_instance_of(String) }
    it { expect(service.errors).to be_empty }
  end

  context "when the credentials are not valid" do
    let(:service) { AuthenticateUser.new(user.email, "wrong password") }

    before { service.perform }

    it { expect(service.result).to be_nil }
    it { expect(service.errors).to eq({ user_authentication: "invalid credentials" }) }
  end
end
