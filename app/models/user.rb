class User < ApplicationRecord
  AVATARS = {
    "orbit" => "Orbit",
    "comet" => "Comet",
    "signal" => "Signal",
    "switch" => "Switch",
    "ticket" => "Ticket",
    "wildflower" => "Wildflower"
  }.freeze

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :username, with: ->(username) { username.strip.downcase }
  validates :email_address, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    length: { in: 3..30 },
    format: { with: /\A[a-z0-9][a-z0-9_-]*\z/, message: "can only contain letters, numbers, hyphens, and underscores" }
  validates :avatar_key, inclusion: { in: AVATARS.keys }

  before_validation :assign_username, on: :create

  generates_token_for :magic_signin, expires_in: 15.minutes do
    magic_link_token_version
  end

  def issue_magic_signin_token!
    increment!(:magic_link_token_version)
    generate_token_for(:magic_signin)
  end

  private
    def assign_username
      return if username.present?

      root = email_address.to_s.split("@", 2).first.to_s.parameterize(separator: "_").gsub(/[^a-z0-9_-]/, "").first(24)
      root = "member" if root.length < 3
      candidate = root
      suffix = 2

      while self.class.exists?(username: candidate)
        suffix_text = "_#{suffix}"
        candidate = "#{root.first(30 - suffix_text.length)}#{suffix_text}"
        suffix += 1
      end

      self.username = candidate
    end
end
