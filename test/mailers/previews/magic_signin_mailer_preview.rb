class MagicSigninMailerPreview < ActionMailer::Preview
  def link
    user = User.new(email_address: "reader@example.com")
    MagicSigninMailer.link(user, "preview-token")
  end
end
