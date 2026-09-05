require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @user = users(:two)
    get magic_session_url(@admin.issue_magic_signin_token!)
  end

  test "updates a user's admin access" do
    patch admin_user_url(@user), params: { user: { is_admin: true } }

    assert_redirected_to admin_root_url
    assert_predicate @user.reload, :is_admin?
  end

  test "does not allow an admin to demote themselves" do
    patch admin_user_url(@admin), params: { user: { is_admin: false } }

    assert_redirected_to admin_root_url
    assert_predicate @admin.reload, :is_admin?
  end

  test "deletes another user and their posts" do
    assert_difference([ "User.count", "Post.count" ], -1) do
      delete admin_user_url(@user)
    end

    assert_redirected_to admin_root_url
  end

  test "does not allow an admin to delete themselves" do
    assert_no_difference("User.count") do
      delete admin_user_url(@admin)
    end

    assert_redirected_to admin_root_url
  end
end
