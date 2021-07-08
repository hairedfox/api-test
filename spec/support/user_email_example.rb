RSpec.shared_examples "wrong email" do |case_name:, email:|
  context case_name do
    subject { build(:user, email: email) }
    it { is_expected.to be_invalid }
    it do
      subject.valid?
      expect(subject.errors.full_messages).to include("Email is not an email")
    end
  end
end
