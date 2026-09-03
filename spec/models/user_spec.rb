require 'rails_helper'

RSpec.describe User, type: :model do
  describe "magic sign-in tokens" do
    it "invalidates a token when a new one is issued" do
      user = described_class.create!(email_address: "reader@example.com", password: SecureRandom.base64(48))
      old_token = user.issue_magic_signin_token!
      new_token = user.issue_magic_signin_token!

      expect(described_class.find_by_token_for(:magic_signin, old_token)).to be_nil
      expect(described_class.find_by_token_for(:magic_signin, new_token)).to eq(user)
    end
  end
end
