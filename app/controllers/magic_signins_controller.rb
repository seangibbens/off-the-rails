class MagicSigninsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 5, within: 10.minutes, only: :create, with: -> { redirect_to new_magic_signin_path, alert: "Please wait a few minutes before requesting another link." }

  def new
    return redirect_to posts_path if authenticated?

    @magic_signin = MagicSignin.new
  end

  def create
    @magic_signin = MagicSignin.new(email_address: magic_signin_params[:email_address])

    if @magic_signin.save
      MagicSigninMailer.link(@magic_signin.user, @magic_signin.user.issue_magic_signin_token!).deliver_now
      redirect_to new_magic_signin_path, notice: "Check your inbox for a secure sign-in link."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def magic_signin_params
      params.expect(magic_signin: :email_address)
    end
end
