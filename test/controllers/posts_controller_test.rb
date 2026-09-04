require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @user = User.create!(email_address: "reader@example.com", password: SecureRandom.base64(48))
    get magic_session_url(@user.issue_magic_signin_token!)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    get new_post_url
    assert_response :success
    assert_select "lexxy-editor.lexxy-content[name='post[body]'][data-direct-upload-url]"
  end

  test "should create post" do
    body = "<p>A <strong>formatted</strong> post.</p>"

    assert_difference("Post.count") do
      post posts_url, params: { post: { body: body, title: @post.title } }
    end

    assert_redirected_to post_url(Post.last)
    assert_equal "A formatted post.", Post.last.body.to_plain_text
    assert_includes Post.last.body.body.to_html, "<strong>formatted</strong>"
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
    assert_select ".post-detail__body .lexxy-content", text: /MyText/
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update post" do
    patch post_url(@post), params: { post: { body: "<p>Updated <em>rich text</em>.</p>", title: @post.title } }
    assert_redirected_to post_url(@post)
    assert_equal "Updated rich text.", @post.reload.body.to_plain_text
  end

  test "index renders a plain text excerpt" do
    @post.update!(body: "<p>Visible <strong>without markup</strong>.</p>")

    get posts_url

    assert_select ".post-row__excerpt", text: "Visible without markup."
    assert_select ".post-row__excerpt strong", count: 0
  end

  test "JSON renders sanitized rich text HTML" do
    @post.update!(body: '<p>Safe <strong>formatting</strong><script>alert("unsafe")</script>.</p>')

    get post_url(@post, format: :json)

    assert_response :success
    body = JSON.parse(response.body).fetch("body")
    assert_includes body, "<strong>formatting</strong>"
    assert_not_includes body, "<script>"
    assert_not_includes body, "lexxy-content"
  end

  test "should destroy post" do
    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end
