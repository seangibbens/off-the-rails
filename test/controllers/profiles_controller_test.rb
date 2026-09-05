require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    get magic_session_url(@user.issue_magic_signin_token!)
  end

  test "shows the current profile with real posts and future activity sections" do
    get profile_url

    assert_response :success
    assert_select "h1", text: @user.username
    assert_select "img.avatar--hero[src*='avatars/#{@user.avatar_key}']"
    assert_select "#profile-posts-heading", text: "Posts"
    assert_select ".profile-post", count: @user.posts.count
    assert_select "#achievements-heading", text: "Achievements"
    assert_select "#game-history-heading", text: "Game history"
    assert_select "a[href='#{edit_profile_path}']", text: /Edit profile/
    assert_not_includes response.body, @user.email_address
  end

  test "shows another member without owner controls or private email" do
    member = users(:two)

    get user_url(member.username)

    assert_response :success
    assert_select "h1", text: member.username
    assert_select "a[href='#{edit_profile_path}']", count: 0
    assert_not_includes response.body, member.email_address
  end

  test "gets the profile editor" do
    get edit_profile_url

    assert_response :success
    assert_select "input[name='user[username]'][value='#{@user.username}']"
    assert_select "input[type='radio'][name='user[avatar_key]']", count: User::AVATARS.size
  end

  test "updates username and avatar" do
    patch profile_url, params: { user: { username: "fresh-track", avatar_key: "signal" } }

    assert_redirected_to user_url("fresh-track")
    assert_equal [ "fresh-track", "signal" ], @user.reload.values_at(:username, :avatar_key)

    follow_redirect!
    assert_response :success
    assert_select "h1", text: "fresh-track"
    assert_select "img.avatar--hero[src*='avatars/signal']"
  end

  test "renders validation errors without changing the profile" do
    assert_no_changes -> { @user.reload.username } do
      patch profile_url, params: { user: { username: "not a username", avatar_key: "orbit" } }
    end

    assert_response :unprocessable_entity
    assert_select ".notice--error", text: /Username can only contain/
  end

  test "does not allow email updates through the profile" do
    patch profile_url, params: { user: { username: @user.username, avatar_key: @user.avatar_key, email_address: "exposed@example.com" } }

    assert_redirected_to user_url(@user.username)
    assert_equal "owner@example.com", @user.reload.email_address
  end

  test "requires authentication" do
    delete session_url

    get profile_url

    assert_redirected_to new_magic_signin_url
  end
end
