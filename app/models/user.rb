class User < ApplicationRecord
  # Validate user id length and character restriction
  validates :id, length: { minimum: 5, maximum: 20 }, uniqueness: true,
    format: { with: /\A[a-z0-9_]*\z/, message: :invalid_characters}, presence: true

  # Add password digest and password confirmation handling
  has_secure_password

  # Validate password presence, length and complexity
  validates :password, length: {minimum: 8, maximum: 64}, allow_nil: true
  validates :password_confirmation, presence: true, if: :password_digest_changed?
  validate :password_complexity

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
end
