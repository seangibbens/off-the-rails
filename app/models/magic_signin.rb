class MagicSignin
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email_address, :string

  validates :email_address, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  attr_reader :user

  def email_address=(value)
    super(value.to_s.strip.downcase)
  end

  def save
    return false unless valid?

    @user = User.find_or_initialize_by(email_address: email_address)
    @user.password = SecureRandom.base64(48) if @user.new_record?
    @user.save!
  rescue ActiveRecord::RecordNotUnique
    @user = User.find_by!(email_address: email_address)
  end
end
