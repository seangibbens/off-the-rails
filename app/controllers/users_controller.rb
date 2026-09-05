class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params.expect(:username).downcase)
    @posts = @user.posts.with_rich_text_body.order(created_at: :desc)
  end
end
