require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = User.create!(email_address: "home@example.com", password: SecureRandom.base64(48))
    get magic_session_url(user.issue_magic_signin_token!)
  end

  test "shows links to each dashboard destination" do
    get root_url

    assert_response :success
    assert_select "h1", text: "Pick a track."
    assert_select ".bento-grid > a:nth-child(1)[href='#{games_path}']", text: /Games/
    assert_select ".bento-grid > a:nth-child(2)[href='#{posts_path}']", text: /Posts/
    assert_select ".bento-grid > a:nth-child(3)[href='#{chat_path}']", text: /Chat/
    assert_select ".bento-grid > a:nth-child(4)[href='#{about_path}']", text: /About/
    assert_select ".timezone-indicator[data-controller='timezone']" do
      assert_select "[data-timezone-target='sun']"
      assert_select "[data-timezone-target='moon']"
      assert_select "[data-timezone-target='label']", text: "Local time"
    end
    assert_select "footer.app-footer" do
      assert_select ".app-footer__name", text: "Your Name"
      assert_select "a", text: /GitHub/
      assert_select "a", text: /LinkedIn/
    end
  end

  test "requires authentication" do
    delete session_url

    get root_url

    assert_redirected_to new_magic_signin_url
  end

  test "shows the admin link only to admins" do
    get root_url

    assert_select "a[href='#{admin_root_path}']", count: 0

    delete session_url
    get magic_session_url(users(:one).issue_magic_signin_token!)
    get root_url

    assert_select "a[href='#{admin_root_path}']", text: "Admin"
  end
end
