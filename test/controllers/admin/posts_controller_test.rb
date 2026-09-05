require "test_helper"

class Admin::PostsControllerTest < ActionDispatch::IntegrationTest
  test "allows an admin to delete another user's post" do
    admin = users(:one)
    post = posts(:two)
    get magic_session_url(admin.issue_magic_signin_token!)

    assert_difference("Post.count", -1) do
      delete admin_post_url(post)
    end

    assert_redirected_to admin_root_url
  end

  test "does not allow a non-admin to delete a post" do
    post = posts(:one)
    get magic_session_url(users(:two).issue_magic_signin_token!)

    assert_no_difference("Post.count") do
      delete admin_post_url(post)
    end

    assert_redirected_to root_url
  end
end
