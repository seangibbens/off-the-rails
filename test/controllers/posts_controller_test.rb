require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @other_post = posts(:two)
    @user = users(:one)
    get magic_session_url(@user.issue_magic_signin_token!)
  end

  test "should get index" do
    get posts_url
    assert_response :success
    assert_select "a.back-link[href='#{root_path}']", text: /Back home/
  end

  test "should get new" do
    get new_post_url
    assert_response :success
    assert_select "lexxy-editor.lexxy-content[name='post[body]'][data-direct-upload-url]"
  end

  test "should create post" do
    body = "<p>A <strong>formatted</strong> post.</p>"

    assert_difference("Post.count") do
      post posts_url, params: { post: { body: body, title: @post.title, user_id: users(:two).id } }
    end

    assert_redirected_to post_url(Post.last)
    assert_equal @user, Post.last.user
    assert_equal "A formatted post.", Post.last.body.to_plain_text
    assert_includes Post.last.body.body.to_html, "<strong>formatted</strong>"
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
    assert_select ".post-detail__body .lexxy-content", text: /MyText/
  end

  test "should show another user's post without write controls" do
    get post_url(@other_post)

    assert_response :success
    assert_select "a[href='#{edit_post_path(@other_post)}']", count: 0
    assert_select "form[action='#{post_path(@other_post)}']", count: 0
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should not edit another user's post" do
    get edit_post_url(@other_post)

    assert_response :not_found
  end

  test "should update post" do
    patch post_url(@post), params: { post: { body: "<p>Updated <em>rich text</em>.</p>", title: @post.title } }
    assert_redirected_to post_url(@post)
    assert_equal "Updated rich text.", @post.reload.body.to_plain_text
  end

  test "should not update another user's post" do
    assert_no_changes -> { @other_post.reload.title } do
      patch post_url(@other_post), params: { post: { title: "Unauthorized" } }
    end

    assert_response :not_found
  end

  test "index renders a plain text excerpt" do
    @post.update!(body: "<p>Visible <strong>without markup</strong>.</p>")

    get posts_url

    assert_select ".post-row__excerpt", text: "Visible without markup."
    assert_select ".post-row__excerpt strong", count: 0
  end

  test "index only renders write controls for owned posts" do
    get posts_url

    assert_select "#post_#{@post.id} .post-row__actions", count: 1
    assert_select "#post_#{@other_post.id} .post-row__actions", count: 0
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

  test "should not destroy another user's post" do
    assert_no_difference("Post.count") do
      delete post_url(@other_post)
    end

    assert_response :not_found
  end
end
