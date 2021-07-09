require "rails_helper"

describe "CommentSerializer" do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:comment) { create(:comment, post: post, content: "Sample comment", user: user) }
  let(:serialize_result) { CommentSerializer.new(comment).serializable_hash }

  it { expect(serialize_result.size).to eq(1) }
  it { expect(serialize_result[:data][:attributes][:content]).to eq("Sample comment") }
  it { expect(serialize_result[:data][:attributes][:user_nickname]).to eq(user.nickname) }
end
