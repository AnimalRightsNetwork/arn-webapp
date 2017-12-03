class User < ApplicationRecord
  # Include random token functionality
  include RandomToken

  # Setup
  after_initialize :set_default_values, if: :new_record?
  before_create :create_activation_token
  has_secure_password

  ######################
  # Attribute handling #
  ######################

  # Make id only writable via display_id
  private :id=
  def display_id= display_id
    self.id = display_id&.downcase
    super display_id
  end

  # Automatically convert email to lower case
  def email= email
    super email&.downcase
  end

  # Create activation token reader
  attr_reader :activation_token

  ################
  # Associations #
  ################

  has_and_belongs_to_many :administrated_orgs, class_name: :Org, join_table: :org_administrations

  ###############
  # Validations #
  ###############

  # Validate user id length and character restriction
  validates :id, length: { minimum: 5, maximum: 25 }, uniqueness: true,
    format: { with: /\A[a-z0-9]*\z/, error: :invalid_characters}, presence: true

  # Validate valid email address
  validates :email, email_format: true, uniqueness: true, presence: true

  # Validate password presence, length and complexity
  validates :password, length: { minimum: 8, maximum: 64 }, allow_nil: true
  validates :password_confirmation, presence: true, if: :password_digest_changed?
  validate :password_complexity

  # Validate activation digest
  validates :activation_digest, presence: true, allow_nil: true

  # Validate admin presence
  validates :admin, inclusion: { in: [true, false] }

  #################
  # Functionality #
  #################

  # Handle user activation
  def activate token
    if !activated? && User.password_matches?(activation_digest, token)
      self.activation_digest = nil
      self.save
      self
    else
      false
    end
  end

  def activated?
    activation_digest == nil
  end

  # Print full error messages except email taken
  def full_error_messages
    error_messages = []
    errors.details.each do |attr, attr_errors|
      attr_errors.each do |error|
        unless attr == :email && error[:error] == :taken
          message = errors.generate_message(attr, error[:error], error)
          error_messages << errors.full_message(attr, message)
        end
      end
    end
    error_messages
  end

  # Check if has any errors other than email taken
  def has_filtered_errors?
    errors.details.each do |attr, attr_errors|
      return true if attr != :email
      attr_errors.each do |error|
        return true if error[:error] != :taken
      end
    end
    false
  end

  ###########
  # Helpers #
  ###########
  private
    # Require password to contain upper case, lower case and digits
    def password_complexity
      unless password.nil? || password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])/)
        errors.add :password, :insufficient_complexity
      end
    end

    # Setup default values
    def set_default_values
      self.admin ||= false
    end

    # Create activation token
    def create_activation_token
      @activation_token = User.new_token
      self.activation_digest = User.password_digest @activation_token
    end

    # Make activation digest read only
    def activation_digest= activation_digest
      super(activation_digest)
    end
end
