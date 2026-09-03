class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  generates_token_for :magic_signin, expires_in: 15.minutes do
    magic_link_token_version
  end

  def issue_magic_signin_token!
    increment!(:magic_link_token_version)
    generate_token_for(:magic_signin)
  end
end
