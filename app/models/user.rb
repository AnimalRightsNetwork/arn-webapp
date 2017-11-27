class User < ApplicationRecord
  # Include random token functionality
  include RandomToken

  # Set default values
  after_initialize :set_default_values, if: :new_record?

  # Setup activation token
  attr_reader :activation_token
  before_create :create_activation_token

  # Validate user id length and character restriction
  validates :id, length: { minimum: 5, maximum: 20 }, uniqueness: true,
    format: { with: /\A[a-z0-9_]*\z/, message: :invalid_characters}, presence: true

  # Validate valid email address
  validates :email, email_format: true, uniqueness: true, presence: true

  # Add password digest and password confirmation handling
  has_secure_password

  # Validate password presence, length and complexity
  validates :password, length: {minimum: 8, maximum: 64}, allow_nil: true
  validates :password_confirmation, presence: true, if: :password_digest_changed?
  validate :password_complexity

  # Validate admin presence
  validates :admin, inclusion: { in: [true, false] }

  # Handle user activation
  def activate token
    if !activated? && User.password_matches?(activation_digest, token)
      self.activation_digest = nil
      self
    else
      false
    end
  end

  def activated?
    activation_digest == nil
  end

  # Helper methods
  private
    # Require password to contain upper case, lower case and digits
    # and length of 8 to 64 characters
    def password_complexity
      unless password.nil?
        unless password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])/)
          errors.add :password, :insufficient_complexity
        end
      end
    end

    # Setup default values
    def set_default_values
      self.admin ||= false
    end

    # Create activation token
    def create_activation_token
      loop do
        @activation_token = User.new_token
        self.activation_digest = User.password_digest @activation_token
        break unless User.exists?(activation_digest: activation_digest)
      end
    end

    # Make activation digest read only
    def activation_digest= activation_digest
      super(activation_digest)
    end
end
