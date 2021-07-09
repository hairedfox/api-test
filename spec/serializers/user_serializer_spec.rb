require "rails_helper"

describe "UserSerializer" do
  let(:user) { create(:user, email: "hai@example.com", nickname: "HaiTest") }
  let(:serialize_result) { UserSerializer.new(user).serializable_hash }

  before do
    create_list(:post, 3, user: user)
  end

  it { expect(serialize_result.size).to eq(1) }
  it { expect(serialize_result[:data][:attributes][:email]).to eq("hai@example.com") }
  it { expect(serialize_result[:data][:attributes][:nickname]).to eq("HaiTest") }
  it { expect(serialize_result[:data][:attributes][:password]).to be_nil }
  it { expect(serialize_result[:data][:attributes][:posts].size).to eq(3) }
end
