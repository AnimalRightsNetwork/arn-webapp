module RandomToken
  extend ActiveSupport::Concern

  module ClassMethods
    # Generate new token
    def new_token
      SecureRandom.urlsafe_base64
    end

    # Digest token with salt
    def password_digest token
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create token, cost: cost
    end

    # Check token match
    def password_matches? digest, token
      BCrypt::Password.new(digest).is_password? token
    end
  end
end
