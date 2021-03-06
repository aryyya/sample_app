EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token

  before_create(:create_activation_digest)
  before_save(:downcase_email)
  validates(:name, presence: true, length: { maximum: 50 })
  validates(:email, presence: true, length: { maximum: 255 }, format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false })
  validates(:password, presence: true, length: { minimum: 8 }, allow_nil: true)
  has_secure_password
  has_many(:microposts, dependent: :destroy)

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    return BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    return SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    return BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_columns(
      activated: true,
      activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes(
      reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    return reset_sent_at < 1.hour.ago
  end

  # Defines a proto-feed.
  def feed
    return Micropost.where('user_id = ?', id)
  end

private

  # Converts email to all lower-case.
  def downcase_email
    self.email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
