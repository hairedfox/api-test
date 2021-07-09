require "rails_helper"

describe "AuthorizeApiRequest" do
  let(:user) { create(:user, id: 2) }

  context "when the authorization header are present and valid" do
    let(:token) { JsonWebToken.encode({ user_id: user.id }) }
    let(:service) { AuthorizeApiRequest.new({ "Authorization" => "Bearer #{token}" }) }

    before { service.perform }

    it { expect(service.result).to eq(user) }
    it { expect(service.errors).to be_empty }
  end

  context "when the authorization header are present and got non-existed user" do
    let(:non_exist_token) { JsonWebToken.encode({ user_id: 1 }) }
    let(:service) { AuthorizeApiRequest.new({ "Authorization" => "Bearer #{non_exist_token}" }) }

    it do
      expect do
        service.perform
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when the authorization header are present and invalid" do
    let(:service) { AuthorizeApiRequest.new({ "Authorization" => "Bearer not_valid" }) }

    it do
      expect do
        service.perform
      end.to raise_error(JWT::DecodeError)
    end
  end

  context "when the token is missing" do
    let(:service) { AuthorizeApiRequest.new() }

    it do
      expect do
        service.perform
      end.to raise_error(JWT::DecodeError)
    end
  end
end
