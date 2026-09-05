require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated visitors to sign in" do
    get admin_root_url

    assert_redirected_to new_magic_signin_url
  end

  test "redirects non-admin users home" do
    sign_in_as users(:two)

    get admin_root_url

    assert_redirected_to root_url
    assert_equal "You are not authorized to access that page.", flash[:alert]
  end

  test "shows user and post management tables to admins" do
    sign_in_as users(:one)

    get admin_root_url

    assert_response :success
    assert_select "h1", "Admin"
    assert_select "#users-heading", "Users"
    assert_select "#admin-posts-heading", "Posts"
    assert_select "#user_#{users(:two).id} form[action='#{admin_user_path(users(:two))}']"
    assert_select "#admin_post_#{posts(:two).id} form[action='#{admin_post_path(posts(:two))}']"
  end

  private
    def sign_in_as(user)
      get magic_session_url(user.issue_magic_signin_token!)
    end
end
