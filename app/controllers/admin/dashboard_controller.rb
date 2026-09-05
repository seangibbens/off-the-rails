module Admin
  class DashboardController < BaseController
    def index
      @users = User.includes(:posts).order(:email_address)
      @posts = Post.includes(:user).order(created_at: :desc)
    end
  end
end
