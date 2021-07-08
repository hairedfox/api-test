require "rails_helper"

describe "BaseService" do
  let(:service) { BaseService.new }

  it { expect(service.result).to be_nil }
  it { expect(service.errors).to eq({}) }
end
