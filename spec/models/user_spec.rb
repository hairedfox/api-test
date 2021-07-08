require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:posts) }

  it { is_expected.to have_secure_password }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:nickname) }

  describe ".email" do
    context "with a correct format" do
      subject { build(:user, email: "hai@example.com") }

      it { is_expected.to be_valid }
    end

    it_behaves_like "wrong email", case_name: "without extension", email: "example@"
    it_behaves_like "wrong email", case_name: "without prefix", email: "@example.com"
    it_behaves_like "wrong email", case_name: "with special characters in prefix", email: "ha$i@example.com"
    it_behaves_like "wrong email", case_name: "with special characters in extension", email: "hai@ex$ample.com"
  end
end
