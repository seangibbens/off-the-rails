require 'rails_helper'

RSpec.describe "Magic sign-ins", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  def magic_token_from(email)
    email.html_part.body.decoded.match(%r{magic-session/([^"<\s]+)})[1]
  end

  it "creates an account and sends a sign-in link" do
    expect {
      post magic_signin_path, params: { magic_signin: { email_address: "reader@example.com" } }
    }.to change(User, :count).by(1).and change(ActionMailer::Base.deliveries, :count).by(1)

    expect(response).to redirect_to(new_magic_signin_path)
    expect(ActionMailer::Base.deliveries.last.to).to eq([ "reader@example.com" ])
  end

  it "starts a session with a valid link and rejects the link after it is used" do
    user = User.create!(email_address: "reader@example.com", password: SecureRandom.base64(48))
    token = user.issue_magic_signin_token!

    expect {
      get magic_session_path(token)
    }.to change(Session, :count).by(1)

    expect(response).to redirect_to(root_url)

    expect {
      get magic_session_path(token)
    }.not_to change(Session, :count)

    expect(response).to redirect_to(new_magic_signin_path)
  end

  it "rejects expired links" do
    user = User.create!(email_address: "reader@example.com", password: SecureRandom.base64(48))
    token = user.issue_magic_signin_token!

    travel 16.minutes do
      get magic_session_path(token)
    end

    expect(response).to redirect_to(new_magic_signin_path)
  end

  it "redirects unauthenticated visitors from posts to the sign-in screen" do
    get posts_path

    expect(response).to redirect_to(new_magic_signin_path)
  end

  it "redirects authenticated visitors from sign-in to home" do
    user = User.create!(email_address: "reader@example.com", password: SecureRandom.base64(48))
    get magic_session_path(user.issue_magic_signin_token!)

    get new_magic_signin_path

    expect(response).to redirect_to(root_path)
  end

  it "expires a session after 30 days" do
    user = User.create!(email_address: "reader@example.com", password: SecureRandom.base64(48))
    get magic_session_path(user.issue_magic_signin_token!)

    travel 30.days + 1.second do
      get posts_path
    end

    expect(response).to redirect_to(new_magic_signin_path)
  end
end
