require "rails_helper"

RSpec.describe Post, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_least(6).is_at_most(255) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_least(20).is_at_most(3_000) }
end
