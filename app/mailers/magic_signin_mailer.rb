class MagicSigninMailer < ApplicationMailer
  def link(user, token)
    @user = user
    @magic_link = magic_session_url(token)

    mail to: @user.email_address, subject: "Your secure sign-in link"
  end
end
