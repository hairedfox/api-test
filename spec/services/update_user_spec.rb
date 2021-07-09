require "rails_helper"

describe "UpdateUser" do
  let!(:user) { create(:user, password: "password", nickname: "Hai") }

  context "when the params include password" do
    let(:params) do
      {
        password: "password1",
        password_confirmation: "password1",
        nickname: "HAREFX"
      }
    end

    let(:service) { UpdateUser.new(params, user) }

    it do
      expect do
        service.perform
      end.to change(User, :count).by(0)

      expect(user.validate("password1")).to be_truthy
      expect(user.nickname).to eq("HAREFX")
    end
  end

  context "when the params exclude the password" do
    let(:params) do
      {
        nickname: "HAREFX"
      }
    end

    let(:service) { UpdateUser.new(params, user) }

    it do
      expect do
        service.perform
      end.to change(User, :count).by(0)

      expect(user.validate("password")).to be_truthy
      expect(user.nickname).to eq("HAREFX")
    end
  end
end
