module Admin
  class UsersController < BaseController
    before_action :set_user

    def update
      if @user == Current.user && !ActiveModel::Type::Boolean.new.cast(user_params[:is_admin])
        redirect_to admin_root_path, alert: "You cannot remove your own admin access."
      elsif @user.update(user_params)
        redirect_to admin_root_path, notice: "#{@user.email_address} was updated."
      else
        redirect_to admin_root_path, alert: @user.errors.full_messages.to_sentence
      end
    end

    def destroy
      if @user == Current.user
        redirect_to admin_root_path, alert: "You cannot delete your own account."
      else
        @user.destroy!
        redirect_to admin_root_path, notice: "#{@user.email_address} was deleted.", status: :see_other
      end
    end

    private
      def set_user
        @user = User.find(params.expect(:id))
      end

      def user_params
        params.expect(user: [ :is_admin ])
      end
  end
end
