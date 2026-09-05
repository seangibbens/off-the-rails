require 'rails_helper'

RSpec.describe MagicSignin, type: :model do
  it "normalizes the email address before creating an account" do
    signup = described_class.new(email_address: "  Reader@Example.COM ")

    expect(signup.save).to be(true)
    expect(signup.user).to have_attributes(email_address: "reader@example.com", username: "reader", avatar_key: "orbit")
    expect(signup.user.password_digest).to be_present
  end

  it "rejects malformed email addresses" do
    signup = described_class.new(email_address: "not-an-email")

    expect(signup.save).to be(false)
    expect(signup.errors[:email_address]).to be_present
  end
end
