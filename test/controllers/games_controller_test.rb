require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    get magic_session_url(@user.issue_magic_signin_token!)
  end

  test "shows Lotto in the game catalog" do
    get games_url

    assert_response :success
    assert_select "h1", text: "Pick your play."
    assert_select "a.back-link[href='#{root_path}']", text: "<- Home"
    assert_select "a[href='#{games_lotto_path}']", text: /Lotto/
  end

  test "shows the Lotto daily draw" do
    get games_lotto_url

    assert_response :success
    assert_select "h1", text: /Pick it/
    assert_select "select[name='chosen_number'] option", count: 2
    assert_select "input[type='submit']:not([disabled])", value: "Spin the wheel"
  end

  test "creates a server-generated play" do
    assert_difference -> { LottoPlay.count }, 1 do
      post games_lotto_play_url(format: :json), params: { chosen_number: 1 }
    end

    assert_response :created
    payload = response.parsed_body
    assert_includes [ true, false ], payload["play"]["won"]
    assert_includes [ 2, 3 ], payload["current_max_number"]
  end

  test "does not create a second daily play" do
    post games_lotto_play_url(format: :json), params: { chosen_number: 1 }

    assert_no_difference -> { LottoPlay.count } do
      post games_lotto_play_url(format: :json), params: { chosen_number: 2 }
    end

    assert_response :success
    assert_equal false, response.parsed_body["created"]
  end

  test "rejects a number outside the current range" do
    assert_no_difference -> { LottoPlay.count } do
      post games_lotto_play_url(format: :json), params: { chosen_number: 3 }
    end

    assert_response :unprocessable_entity
    assert_equal "Choose a number between 1 and 2.", response.parsed_body["error"]
  end

  test "renders today's result after playing" do
    post games_lotto_play_url, params: { chosen_number: 1 }
    follow_redirect!

    assert_response :success
    assert_select ".lotto-result"
    assert_select "input[type='submit'][disabled]", value: "Played today"
  end

  test "requires authentication" do
    delete session_url

    get games_lotto_url

    assert_redirected_to new_magic_signin_url
  end
end
