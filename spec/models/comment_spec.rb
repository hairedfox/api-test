require "rails_helper"

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to(:post) }

  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_length_of(:content).is_at_least(3).is_at_most(255) }
end
