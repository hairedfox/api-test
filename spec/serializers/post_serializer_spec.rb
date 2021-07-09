require "rails_helper"

describe "PostSerializer" do
  let(:user) { create(:user) }
  let(:post) { create(:post, title: "Test post", body: "Sample content for the body", user: user) }
  let(:serialize_result) { PostSerializer.new(post).serializable_hash }

  it { expect(serialize_result.size).to eq(1) }
  it { expect(serialize_result[:data][:attributes][:title]).to eq("Test post") }
  it { expect(serialize_result[:data][:attributes][:body]).to eq("Sample content for the body") }
  it { expect(serialize_result[:data][:attributes][:user_nickname]).to eq(user.nickname)}
end
