require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should only save with correct id length" do
    # Test id too short
    u = User.create default_options.merge(display_id: 'Shrt')
    assert_not u.save
    assert_not_empty u.errors[:id]

    # Test id too long and invalid characters
    u.display_id = "This1IsTooLongtousea$"
    assert_not u.save
    assert_not_empty u.errors[:id]

    # Test lower limit
    u.display_id = "Short"
    assert u.save

    # Test upper limit
    u.display_id = "This1IsNotTooLongToU"
    assert u.save
  end

  test "should only save with valid characters" do
    # Test invalid characters
    u = User.create default_options.merge(display_id: 'In^alid')
    assert_not u.save
    assert_not_empty u.errors[:id]

    # Test invalid characters and too short
    u.display_id = 'In^4'
    assert_not u.save
    assert_not_empty u.errors[:id]

    # Test only valid characters
    u.display_id = 'Valid'
    assert u.save
  end

  test "should only save with valid password and confirmation" do
    # Test without password
    u = User.create display_id: 'Valid', email: 'valid@example.com'
    assert_not u.save
    assert_not_empty u.errors[:password]

    # Test with too short password
    u.password = u.password_confirmation = 'T00shrt'
    assert_not u.save
    assert_not_empty u.errors[:password]

    # Test with too long password
    u.password = u.password_confirmation = "A0#{'a' * 63}"
    assert_not u.save
    assert_not_empty u.errors[:password]

    # Test lower limit
    u.password = u.password_confirmation = 'L0ngengh'
    assert u.save

    # Test upper limit
    u.password = u.password_confirmation = "A0#{'a' * 62}"
    assert u.save

    # Test without digits
    u.password = u.password_confirmation = "NoDigitsAtAll"
    assert_not u.save
    assert_not_empty u.errors[:password]

    # Test missing confirmation
    u.password = "MyPassw0rd"
    u.password_confirmation = nil
    assert_not u.save
    assert_empty u.errors[:password]
    assert_not_empty u.errors[:password_confirmation]

    # Test not matching
    u.password = (u.password_confirmation = "MyPassw0rd") + "a"
    assert_not u.save
    assert_empty u.errors[:password]
    assert_not_empty u.errors[:password_confirmation]
  end

  test "should save without new password" do
    # Create valid user
    u = User.new default_options.merge(display_id: 'OldPassword', email: 'oldpassword@example.com')
    assert u.save

    # Reload user and change id
    u = User.find 'oldpassword'
    u.display_id = 'OldPasswordChanged'

    # Save without new password
    assert_nil u.password
    assert_nil u.password_confirmation
    assert u.save
  end

  test "should enforce uniqueness on user id" do
    u1 = User.new default_options.merge(display_id: 'Uniqueid', email: 'unique1@example.com')
    u2 = User.new default_options.merge(display_id: 'UNIQUEID', email: 'unique2@example.com')
    assert u1.save
    assert_not u2.save
    assert_not_empty u2.errors[:id]
  end

  test "should only save with valid email address" do
    # Test without email
    u = User.new default_options.merge(display_id: 'InvalidEmail', email: nil)
    assert_not u.save
    assert_not_empty u.errors[:email]

    # Test with invalid email
    u.email = "invalid@email"
    assert_not u.save
    assert_not_empty u.errors[:email]
  end

  test "should enforce uniqueness on email" do
    u1 = User.new default_options.merge(display_id: 'Unique1', email: 'unique@example.com')
    u2 = User.new default_options.merge(display_id: 'Unique2', email: 'unique@example.com')
    assert u1.save
    assert_not u2.save
    assert_not_empty u2.errors[:email]
  end

  test "should only make activation_digest writable through 'save' and 'activate'" do
    # Create user
    u = User.new default_options.merge(display_id: 'Activation', email: 'activation@example.com')
    
    # Test unspecified tokens
    assert_nil u.activation_token
    assert_nil u.activation_digest

    # Test private setters
    assert_raises NoMethodError do u.activation_token = "hello" end
    assert_raises NoMethodError do u.activation_digest = "hello" end

    # Test generation of tokens
    assert u.save
    assert_not_nil token = u.activation_token
    assert_not_nil u.activation_digest

    # Reload user
    u = User.find 'activation'

    # Test user not being activated by default
    assert_not u.activated?

    # Test user activation
    assert_not u.activate "invalid token"
    assert_equal u, u.activate(token)

    # Test user being activated after activation
    assert u.activated?
  end

  # Default options
  def default_options
    {
      password: "MyPassw0rd",
      password_confirmation: "MyPassw0rd",
      email: 'test@example.com'
    }
  end
end
