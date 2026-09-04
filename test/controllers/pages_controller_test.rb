require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = User.create!(email_address: "pages@example.com", password: SecureRandom.base64(48))
    get magic_session_url(user.issue_magic_signin_token!)
  end

  test "shows the notes placeholder" do
    get notes_url

    assert_response :success
    assert_select "h1", text: "Notes"
  end

  test "shows the games placeholder" do
    get games_url

    assert_response :success
    assert_select "h1", text: "Games"
  end

  test "shows the about placeholder" do
    get about_url

    assert_response :success
    assert_select "h1", text: "About"
  end

  test "requires authentication" do
    delete session_url

    get notes_url

    assert_redirected_to new_magic_signin_url
  end
end
