class MagicSessionsController < ApplicationController
  allow_unauthenticated_access

  def show
    user = User.find_by_token_for(:magic_signin, params[:token])

    if user && consume_token_for(user)
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_magic_signin_path, alert: "That sign-in link is invalid or has expired. Request a new one to continue."
    end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to new_magic_signin_path, alert: "That sign-in link is invalid or has expired. Request a new one to continue."
  end

  private
    def consume_token_for(user)
      user.with_lock do
        user.reload
        next false unless User.find_by_token_for(:magic_signin, params[:token]) == user

        user.increment!(:magic_link_token_version)
        true
      end
    end
end
