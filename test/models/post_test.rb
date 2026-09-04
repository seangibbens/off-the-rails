require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "body is stored as rich text" do
    post = Post.create!(title: "Formatted", body: "<p>Hello <strong>world</strong>.</p>")

    assert_instance_of ActionText::RichText, post.body
    assert_equal "Hello world.", post.body.to_plain_text
  end
end
