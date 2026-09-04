require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "body is stored as rich text" do
    post = users(:one).posts.create!(title: "Formatted", body: "<p>Hello <strong>world</strong>.</p>")

    assert_instance_of ActionText::RichText, post.body
    assert_equal "Hello world.", post.body.to_plain_text
  end

  test "requires a user" do
    post = Post.new(title: "Ownerless")

    assert_not post.valid?
    assert_includes post.errors[:user], "must exist"
  end

  test "is destroyed with its user" do
    user = User.create!(email_address: "temporary@example.com", password: SecureRandom.base64(48))
    post = user.posts.create!(title: "Temporary")

    user.destroy!

    assert_not Post.exists?(post.id)
  end
end
