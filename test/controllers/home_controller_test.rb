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
    assert_select ".bento-grid a[href='#{posts_path}']", text: /Posts/
    assert_select ".bento-grid a[href='#{notes_path}']", text: /Notes/
    assert_select ".bento-grid a[href='#{games_path}']", text: /Games/
    assert_select ".bento-grid a[href='#{about_path}']", text: /About/
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
end
