require "rails_helper"

describe "CreateUser" do
  context "when the params are all valid" do
    let(:params) do
      {
        email: "hai@example.com",
        password: "password",
        password_confirmation: "password",
        nickname: "HAREFX"
      }
    end

    let(:service) { CreateUser.new(params) }

    it do
      expect do
        service.perform
      end.to change(User, :count).by(1)

      user = User.last

      expect(user.email).to eq("hai@example.com")
      expect(user.nickname).to eq("HAREFX")
      expect(user.authenticate("password")).to be_truthy
    end
  end
end
