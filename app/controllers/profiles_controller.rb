class ProfilesController < ApplicationController
  before_action :set_user

  def show
    @posts = @user.posts.with_rich_text_body.order(created_at: :desc)
    render "users/show"
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to user_path(@user.username), notice: "Your profile was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def profile_params
      params.expect(user: [ :username, :avatar_key ])
    end
end
