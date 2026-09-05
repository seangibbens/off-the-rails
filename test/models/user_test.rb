require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "generates a username and default avatar for a new account" do
    user = User.create!(email_address: "New.Reader@example.com", password: SecureRandom.base64(48))

    assert_equal "new_reader", user.username
    assert_equal "orbit", user.avatar_key
  end

  test "adds a suffix when a generated username is already taken" do
    User.create!(email_address: "reader@first.example", password: SecureRandom.base64(48))
    user = User.create!(email_address: "reader@second.example", password: SecureRandom.base64(48))

    assert_equal "reader_2", user.username
  end

  test "normalizes an explicitly chosen username" do
    user = users(:one)

    assert user.update(username: "  New-Handle  ")
    assert_equal "new-handle", user.username
  end

  test "rejects invalid usernames" do
    user = users(:one)

    assert_not user.update(username: "not a handle")
    assert_includes user.errors[:username], "can only contain letters, numbers, hyphens, and underscores"
  end

  test "rejects unknown avatar keys" do
    user = users(:one)

    assert_not user.update(avatar_key: "unknown")
    assert user.errors[:avatar_key].present?
  end
end
